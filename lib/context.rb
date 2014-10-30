class Context < Struct.new(:landing, :current_context)
  def landing=(value)
    ResetWorld.call    
    super(value)
  end
end
