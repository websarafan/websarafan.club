# -*- coding: utf-8 -*-

module Dictionary
  module Assets
    class Asset < Struct.new(:title, :talk, :video_block, :slides_block); end

    module ClassMethods
      def assets_source
        YAML.load_file('config/data/assets.yml')
      end

      def assets
        [
          *Query[:assets_source]['assets'].map do |title, vimeo_id, slides_title|
            Asset.new.tap do |asset|
              asset.title = title
              asset.talk = Query[:talks].find { |t| t.title == title }
              asset.video_block = vimeo_block(vimeo_id)
              asset.slides_block = slides_block(slides_title)
            end
          end,
          *Query[:assets_source]['exceptions'].map do |title, video_url, slides_url|
            Asset.new.tap do |asset|
              asset.title = title
              asset.video_block = video_ex_block(video_url)
              asset.slides_block = slides_ex_block(slides_url)
              asset.talk = Query[:talks].find { |t| t.title == title  }
            end
          end
        ]
      end

      def talks_to_assets
        Query[:assets].reduce({}) do |hash, asset|
          hash[asset.talk] = asset
          hash
        end
      end

      private

      def video_ex_block(video_url)
        <<-HTML.html_safe
          <a href="#{video_url}">ВИДЕО</a>
        HTML
      end

      def slides_ex_block(slides_url)
        %Q{<a href="#{slides_url}">Скачать презентацию</a>}.html_safe
      end

      def vimeo_block(id)
        <<-HTML.html_safe
          <iframe src="//player.vimeo.com/video/#{id}" width="480" height="375" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
        HTML
      end

      def slides_block(title)
        <<-HTML.html_safe
          <a href="https://s3-eu-west-1.amazonaws.com/sarafan-summit-nov-14/#{title}">скачать презентацию</a>
        HTML
      end
    end
  end
end
