require 'sqlite3'
require 'sequel'

module Dictionary
  module Payments
    class Notification < Struct.new(:data);
      require 'json'

      def to_json
        self.data.to_json
      end
    end
    
    module ClassMethods
      
      def payments_db
        Sequel.connect('sqlite://payments.db').tap do |db|
          db.create_table? :payments do
            primary_key :id
            String :data
          end
        end[:payments]
      end
      
      def process_notification!(data)
        Query[:payments_db].insert(data: Notification.new(data).to_json)
      end
    end
  end
end
