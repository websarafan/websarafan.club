module Dictionary
  module Benefits
    class Benefit < Struct.new(:title, :desc); end

    module ClassMethods
      def benefits_source
        YAML.load_file(
          if File.exists?(path = "config/data/#{Context.landing}/benefits.yml")
            path
          else            
            'config/data/benefits.yml'
          end)['benefits']        
      end
      
      def benefits
        Query[:benefits_source].map do |title, desc|
          Benefit.new(title, desc)
        end
      end
    end
  end
end
