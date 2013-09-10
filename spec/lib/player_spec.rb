require_relative '../spec_helper'

describe 'An Instance of Player', MediaPlayer::Player do
  subject { MediaPlayer::Player.new }
  it { subject.process_manager.should_not be_nil }
  it { subject.shuffle.should eql false }
  it { subject.repeat.should eql false }

  context 'when initialized without any media' do
    it { subject.playlist.should be_nil }
  end

  context 'when initialized with some media' do
    let(:player) { MediaPlayer::Player.new(['a.mp3', 'b.wav']) }
    it { player.playlist.should_not be_nil }

    context 'when toggling shuffle' do
      before(:each) { player.toggle_shuffle }
      context 'when shuffle is false' do
        it { player.shuffle.should eql true }
      end
      context 'when shuffle is true' do
        before { player.toggle_shuffle }
        it { player.shuffle.should eql false }
      end
    end

    context 'when toggling repeat' do
      before(:each) { player.toggle_repeat }
      context 'when repeat is false' do
        it { player.repeat.should eql true }
      end
      context 'when repeat is true' do
        before { player.toggle_repeat }
        it { player.repeat.should eql false }
      end
    end

    context 'when playing media' do
      it 'plays the media in the playlist' do
        player.playlist.should_receive(:play)
        player.play
      end
    end

    context 'when changing media' do
      it 'plays the next media from the playlist' do
        player.playlist.should_receive(:next)
        player.next
      end
    end
  end

end
