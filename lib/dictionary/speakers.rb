module Dictionary
  module Speakers
    class Speaker < Struct.new(:name, :desc, :gen_avatar_link, :gen_profile_link, :articles, :facebook)

      def translit
        I18n.transliterate(self.name.split.join)
      end

      def topics
        @topics ||=\
          Query[:schedule].flat_map { |day| day.talks.select { |talk| talk.speaker == self }.flat_map(&:topics) }
      end

      def topics_headline
        @topics_headline ||=
          if talk = Query[:schedule].flat_map(&:talks).find { |talk| talk.speaker == self }
            talk.topics_headline
          end
      end
    end

    module ClassMethods
      def gen_speaker_photo_link(name, view)
        view.image_url("speakers/#{name.split.join}.jpg")
      end

      def gen_speaker_profile_link(name, view)
        view.speaker_path(I18n.transliterate(name.split.join))
      end

      def speakers_names
        self.speakers.map(&:name)
      end

      def page_to_speaker_map
        self.speakers.inject({}) do |res, speaker|
          res[speaker.translit] = speaker
          res
        end
      end

      def speakers_source
        YAML.load_file(
          if File.exists?(path = "config/data/#{Context.landing}/speakers.yml")
            path
          else
            'config/data/speakers.yml'
          end)['speakers']
      end

      def speakers
        Query[:speakers_source].map do |name, desc, articles, facebook|
          name_aux = name.split.join
          Speaker.new(
            name,
            desc,
            method(:gen_speaker_photo_link).to_proc.curry[name].freeze,
            method(:gen_speaker_profile_link).to_proc.curry[name].freeze,
            articles,
            facebook
          )
        end
      end
    end
  end
end
