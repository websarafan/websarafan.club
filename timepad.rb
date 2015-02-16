require 'httparty'
require 'dotenv'

Dotenv.load

API_ID  = ENV['TP_API_ID']
API_KEY = ENV['TP_API_KEY']

BANNED = [179921, 161013]

class Timepad
  include HTTParty
  base_uri "http://timepad.ru/api/"
  
  class Options < Hash

    def query(hash)
      { query: self[:query].merge(hash) }
    end
  end

  def initialize(id, key)
    @options = Options[query: { code: key, id: id }]
  end

  def events_list( date_from = nil)
    self.class.get('/event_getlist', @options.query(date_from: date_from)).parsed_response
  end

  def event_details(event_id)    
    self.class.get('/event_get', @options.query(e_id: event_id)).parsed_response
  end

end

require 'pathname'
require 'time'

data_path = Pathname.new('./timepad-data')

unless (data_path = Pathname.new('./timepad-data')).exist?
  data_path.mkdir
end

if (timestamp_file = (data_path + './timestamp')).exist?
  timestamp = Time.at( timestamp_file.read.to_i )
end

Timepad.new(API_ID, API_KEY).tap do |api|
  api.events_list(timestamp).each do |event|

    next if BANNED.include?(event['id'].to_i)

    api.event_details(event['id']).tap do |details|
      (data_path + event['id']).open('w') do |f|
        f.write(details.to_json)
      end
      unless (webinar_photo = (data_path + "#{event['id']}.png")).exist?
        webinar_photo.open('w') do |f|
          f.write(HTTParty.get(details['photo']))
        end
      end
    end    
  end
  timestamp_file.open('w') { |f| f.write(Time.now.to_i.to_s) }  
end
