require_relative '../spec_helper'

describe MediaPlayer do
  it '.start' do
    MediaPlayer::InputManager.any_instance.should_receive(:start).with(no_args())
    MediaPlayer.start
  end
end
