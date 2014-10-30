require 'dictionary'
require 'context'

class World
  def initialize(saved_state)
    @cache = Struct.new( *Dictionary.methods(false) ).new
  end
  def query(query)
    @cache[query] ||= Dictionary.send(query.to_sym)
  end

  def self.new_context
    Context.new
  end
end

