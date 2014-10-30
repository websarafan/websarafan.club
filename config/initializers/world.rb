require 'world'
world = World.new({})
Query = ->(query) { world.query(query) }
Context = World.new_context
