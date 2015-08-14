module Dictionary
  module Partners

    class Partner < Struct.new(:name, :code); end

    module ClassMethods

      def partners_source
        YAML.load_file('config/data/partners.yml')['partners']
      end
      
      def partners
        Query[:partners_source].map do |(name, code)| 
          Partner.new(name, code)
        end
      end   

      def partners_codes
        Query[:partners].map(&:code)
      end
    end
  end
end
