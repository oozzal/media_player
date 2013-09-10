require_relative '../../spec_helper'

describe MediaPlayer do
  it 'has a version' do
    MediaPlayer::VERSION.should_not be_nil
  end
end