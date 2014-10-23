module Dictionary
  class Speaker < Struct.new(:name, :desc, :gen_avatar_link, :gen_profile_link)
    def translit
      I18n.transliterate(self.name.split.join)
    end
  end

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

  def self.speakers_page_to_name
    self.speakers.inject({}) do |res, speaker| 
      res[speaker.translit] = speaker.name
      res
    end    
  end

  def self.speakers
    I18n.t('speakers').map do |name, desc|
      name_aux = name.split.join
      Speaker.new(
        name, 
        desc,        
        method(:gen_speaker_photo_link).to_proc.curry[name],
        method(:gen_speaker_profile_link).to_proc.curry[name]
      )      
    end
  end
end
