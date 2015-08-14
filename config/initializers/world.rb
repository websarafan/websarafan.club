require 'world'
ResetWorld = -> do
  $world = World.new({})
  Query = ->(*args) { $world.query(*args) }
end.tap { |reset| reset.call }
Context = $world.context
