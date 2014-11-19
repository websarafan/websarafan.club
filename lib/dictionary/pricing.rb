module Dictionary
  module Pricing
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
        if ap = Query[:actual_priceline, product]
          [:valid_till, :amount, :discount].zip(
            [*ap, Query[:promo_price, product]]
          ).to_h
        end
      end

      def pricelines( product )
        Query[:pricing][product][:pricelines]
      end

      def promocodes( product )
        Query[:pricing][product][:promocodes]
      end

      def promo_price( product )
        if promocode = Context.promocode
          Query[:promocodes, product][promocode]
        end
      end

      def actual_priceline( product )
        Query[:pricelines, product].find do |(date, _)|
          date > Date.today 
        end
      end

      def products
        Query[:pricing].keys
      end

    end
  end
end
