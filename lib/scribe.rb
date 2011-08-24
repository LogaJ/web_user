class Scribe

  def initialize
    @notepad = {}
  end

  def take_note_of key, something
    @notepad.merge!(key => something)
  end

  def look_up something
    @notepad[something]
  end
end
