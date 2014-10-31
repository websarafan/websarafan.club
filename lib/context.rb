class Context < Struct.new(:landing, :current_context, :promocode)
  def landing=(value)
    ResetWorld.call    
    super(value)
  end
end
