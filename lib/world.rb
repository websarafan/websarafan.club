require 'dictionary'
require 'context'

class World
  def initialize(saved_state)
    # @cache = Struct.new( *Dictionary.class_variable_get(:@@features) ).new
    @cache = {}
  end

  def gen_query_key(query, *args)
    if args.empty?
      query
    else
      [query, *args]
    end
  end

  def query(query, *args)
    @cache[ gen_query_key(query, *args) ] ||= Dictionary.send(query.to_sym, *args)
  end

  def self.new_context
    Context.new
  end

end
