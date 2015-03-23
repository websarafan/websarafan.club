module Dictionary
  @@features = []

  def self.use( dictionary )
    require "dictionary/#{dictionary}"
    mod = "Dictionary::#{dictionary.capitalize}".constantize
    class_methods = mod::ClassMethods
    extend(mod::ClassMethods)
    @@features += mod::ClassMethods.public_instance_methods(false)
    include(mod)
  end

  use :benefits
  use :pricing
  use :speakers
  use :schedule
  use :partners
  use :access
  use :assets
  use :webinars
  use :payments
end
