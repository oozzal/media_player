require_relative './input_manager'

module MediaPlayer
  extend self
  def start
    MediaPlayer::InputManager.new.start
  end
end
