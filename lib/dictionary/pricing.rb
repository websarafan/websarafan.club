module Dictionary
  module Pricing
    def self.included(base)
      base.extend(ClassMethods)
      base.class_variable_set(
        :@@features, 
        base.class_variable_get(:@@features) + ClassMethods.public_instance_methods(false))
    end

    class Price < Struct.new(:product, :pricelines, :promocodes); end
    class Priceline < Struct.new(:valid_till, :price); end
    
    module ClassMethods
      def pricing_source
        YAML.load_file('config/data/pricing.yml')['pricing']
      end

      def pricing
        Query[:pricing_source].reduce({}) do |res, (product, price_aux)|
          key = product.to_sym
          res[key] = Price.new
          res[key][:pricelines] = (price_aux['prices'] || []).reduce({}) do |hash, (valid_till, price)| 
            hash[Date.parse(valid_till)] = price
            hash
          end
          res[key][:promocodes] = (price_aux['promocodes'] || {})
          res
        end
      end

      def price( product = :live )
        date_aux = nil
        pricing = Query[:pricing][product]
        [:valid_till, :amount, :discount].zip(
          pricing[:pricelines].find do |(date, _)|
            date > Date.today
          end.dup.tap do |array| 
            if Context.promocode && (price = pricing[:promocodes][Context.promocode])
              array[2] = price
            end
          end
        ).to_h
      end
    end
    
  end
end
