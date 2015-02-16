require 'pathname'
require 'json'
require 'date'

module Dictionary
  module Webinars
    class Webinar < Struct.new(
      :id,
      :name,
      :date,
      :status,
      :shortdescription,
      :description,
      :link,
      :photo,
      :tickets_count,
      :video_block
    );
    end

    module ClassMethods

      def webinars_data_dir
        Pathname.new('./timepad-data/').expand_path.to_s
      end

      def webinars_ids
        Pathname.
          new(Query[:webinars_data_dir]).
          entries.
          map(&:to_s).
          select { |x| x[/^\d+$/] }.
          sort { |x,y| y <=> x }
      end

      def webinars
        Query[:webinars_ids].map { |id| Query[:webinar, id]}
      end

      def webinar(id)
        video_file = Pathname.new(Query[:webinars_data_dir]) + "#{id}_video"
        data = JSON.parse((Pathname.new(Query[:webinars_data_dir]) + id.to_s).read)
        Webinar.new(
          *(Webinar.members.map { |m| data[m.to_s] })
        ).tap do |res|
           res.date = Date.parse(res.date)
           res.tickets_count = data['registrations'].map { |x| x['ticketsPurchased']}.reduce(&:+)
           if video_file.exist?
             if (id = video_file.read[/\d+/].to_i) > 0
               res.video_block = vimeo_block(video_file.read[/\d+/])
             else
               res.video_block = :not_available
             end
           end
        end
      end

      private

      def vimeo_block(id)
        <<-HTML.html_safe
          <iframe src="//player.vimeo.com/video/#{id}" width="480" height="375" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
          HTML
      end
    end
  end
end
