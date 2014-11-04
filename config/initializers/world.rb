require 'world'
ResetWorld = -> do  
  Query = ->(*args) { World.new({}).query(*args) }  
end
ResetWorld.call
Context = World.new_context
