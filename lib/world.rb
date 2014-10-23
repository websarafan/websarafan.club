require 'dictionary'

class World
  def initialize(saved_state)
    @cache = {}
  end
  def query(query)
    unless @cache.has_key?(query)
      @cache[query] = Dictionary.send(query.to_sym)
    end
    @cache[query]
  end
end

