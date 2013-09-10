require_relative '../spec_helper'

describe 'An Instance of Playlist', MediaPlayer::PlayList do
  subject { MediaPlayer::PlayList.new(['a.mp3', 'b.wav']) }
  context 'when initialized' do
    it { subject.media.should_not be_nil }
    it { subject.media.should_not be_empty }
  end
end