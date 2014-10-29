module Dictionary
  class Speaker < Struct.new(:name, :desc, :gen_avatar_link, :gen_profile_link, :articles, :topics_headline, :topics, :facebook)
    def translit
      I18n.transliterate(self.name.split.join)
    end
  end

  class Day < Struct.new(:date, :headline, :talks); end
  class Talk < Struct.new(:row, :speaker, :time, :title, :details); end


  def self.price
    date_aux = nil
    [:valid_till, :amount].zip(
      I18n.t('prices').find do |date, price| 
        (date_aux = Date.parse(date)) > Date.today  
      end.tap { |array| array[0] = date_aux }
    ).to_h
  end

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

  def self.speakers
    I18n.t('speakers').map do |name, desc, articles, (topics_headline, *topics)|
      name_aux = name.split.join
      Speaker.new(
        name, 
        desc,        
        method(:gen_speaker_photo_link).to_proc.curry[name],
        method(:gen_speaker_profile_link).to_proc.curry[name],
        articles,
        topics_headline,
        topics
      )      
    end
  end

  def self.schedule
    first_day_aux, *daily_tables = I18n.t('schedule')
    first_day = Date.parse(first_day_aux)
    daily_tables.each_with_index.map do |(headline, talks_rows), index| 
      Day.new.tap do |day| 
        day.date = first_day + index        
        day.headline = headline
        day.talks = talks_rows.map do |talk_row| 
          Talk.new.tap do |talk| 
            match = talk_row.match /^(?<time>\d\d\.\d\d)\ (?<title>.+?)\ \((?<name>.+)\)$/
            talk.row = talk_row
            talk.time = match[:time]
            talk.title = match[:title]              
            talk.speaker = Query[:speakers].find { |speaker| speaker.name == match[:name] }
          end
        end.select(&:speaker)
      end
    end
  end
end
