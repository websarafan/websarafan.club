module Dictionary
  module Schedule
    class Day < Struct.new(:date, :headline, :talks); end
    class Talk < Struct.new(:row, :speaker, :time, :title, :topics_headline, :topics); end

    module ClassMethods
      def schedule_source
        YAML.load_file(
          if File.exists?(path = "config/data/#{Context.landing}/schedule.yml")
            path
          else
            'config/data/schedule.yml'
          end)['schedule']
      end

      def schedule
        first_day_aux, *daily_tables = Query[:schedule_source]
        first_day = Date.parse(first_day_aux)
        daily_tables.each_with_index.map do |(headline, talks), index|
          Day.new.tap do |day|
            day.date = first_day + index
            day.headline = headline
            day.talks = talks.map do |talk_row, topics_headline, *topics|
              Talk.new.tap do |talk|
                match = talk_row.match /^(?<time>\d\d\.\d\d)\ (?<title>.+)\ \((?<name>.+)\)$/
                talk.row = talk_row
                talk.time = match[:time]
                talk.title = match[:title]
                talk.speaker = Query[:speakers].find { |speaker| speaker.name == match[:name] }
                talk.topics_headline = topics_headline
                talk.topics = topics
              end
            end.select(&:speaker)
          end
        end
      end
    end
  end
end
