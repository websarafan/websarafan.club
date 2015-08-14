module Dictionary
  module Products
    class Product < Struct.new(:label,
                               :header,
                               :points,
                               :short_desc
                              )
    end

    module ClassMethods

      def products_source
        YAML.load_file('config/data/products.yml')['products']
      end
 
      def products_dict
        Query[:products_source].reduce({}) do |res, (label, info)|
          res[label.to_sym] = Product.new(label,
                                          info['header'],
                                          info['points'],
                                          info['short_desc']
                                         )
          res
        end
      end

      def product(label)
        Query[:products_dict][label]
      end
    end
  end
end
