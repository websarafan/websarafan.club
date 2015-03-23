require 'dictionary'
require 'world_context'

class World
  attr_reader :context

  def initialize(saved_state)
    # @cache = Struct.new( *Dictionary.class_variable_get(:@@features) ).new
    @cache = {}
    @context = WorldContext.new
  end

  def gen_query_key(query, *args)
    if args.empty?
      query
    else
      [query, *args]
    end
  end

  def query(query, *args)
    if query[-1] == '!'
      Dictionary.send(query.to_sym, *args)
    else
      @cache[ gen_query_key(query, *args) ] ||= Dictionary.send(query.to_sym, *args)      
    end
  end

end
