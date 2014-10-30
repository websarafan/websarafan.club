require 'dictionary'
require 'context'

class World
  def initialize(saved_state)    
    @cache = Struct.new( *Dictionary.class_variable_get(:@@features) ).new
  end

  def query(query)
    @cache[query] ||= Dictionary.send(query.to_sym)
  end

  def self.new_context
    Context.new
  end

end

