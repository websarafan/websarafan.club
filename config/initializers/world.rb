require 'world'
world = World.new({})
Query = ->(query) { world.query(query) }
