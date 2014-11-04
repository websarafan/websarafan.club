require 'dictionary/benefits'
require 'dictionary/pricing'

module Dictionary
  @@features = []
  include Dictionary::Benefits
  include Dictionary::Pricing

  class Speaker < Struct.new(:name, :desc, :gen_avatar_link, :gen_profile_link, :articles, :facebook)

    def translit
      I18n.transliterate(self.name.split.join)
    end

    def topics
      @topics ||=\
        Query[:schedule].flat_map { |day| day.talks.select { |talk| talk.speaker == self }.flat_map(&:topics) }
    end

    def topics_headline
      @topics_headline ||=\
        if talk = Query[:schedule].flat_map(&:talks).find { |talk| talk.speaker == self }
          talk.topics_headline
        end
    end
  end

  class Day < Struct.new(:date, :headline, :talks); end
  class Talk < Struct.new(:row, :speaker, :time, :title, :topics_headline, :topics); end

  def self.gen_speaker_photo_link(name, view)
    view.image_path("speakers/#{name.split.join}.jpg")
  end

  def self.gen_speaker_profile_link(name, view)
    view.speaker_path(I18n.transliterate(name.split.join))
  end

  def self.speakers_names
    self.speakers.map(&:name)
  end

  def self.page_to_speaker_map
    self.speakers.inject({}) do |res, speaker|
      res[speaker.translit] = speaker
      res
    end
  end

  def self.speakers_source
    YAML.load_file(
      if File.exists?(path = "config/data/#{Context.landing}/speakers.yml")
        path
      else
        'config/data/speakers.yml'
      end)['speakers']
  end

  def self.schedule_source
    YAML.load_file(
      if File.exists?(path = "config/data/#{Context.landing}/schedule.yml")
        path
      else
        'config/data/schedule.yml'
      end)['schedule']
  end

  def self.speakers
    Query[:speakers_source].map do |name, desc, articles, facebook|
      name_aux = name.split.join
      Speaker.new(
        name,
        desc,
        method(:gen_speaker_photo_link).to_proc.curry[name],
        method(:gen_speaker_profile_link).to_proc.curry[name],
        articles,
        facebook
      )
    end
  end

  def self.schedule
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
  @@features += Dictionary.methods(false)
end
