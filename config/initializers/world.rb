require 'world'
ResetWorld = -> do  
  Query = ->(query) { World.new({}).query(query) }  
end
ResetWorld.call
Context = World.new_context
