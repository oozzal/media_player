require_relative '../spec_helper'

describe 'An Instance of Playlist', MediaPlayer::PlayList do
  subject { MediaPlayer::PlayList.new(['a.mp3', 'b.wav', 'c.mp3', 'd.wav']) }
  context 'when initialized' do
    it { subject.media.should_not be_nil }
    it { subject.media.should_not be_empty }
    it { subject.current_index.should_not be_nil }
  end

  context '#add' do
    let(:sample_media) { 'imagine.mp3' }
    before { subject.add(sample_media) }
    it { expect(subject.media.include?(sample_media)).to eql true }

    context 'when illegal characters occur in the path to media' do
      let(:malicious_media) { '(02) - John Mayer Assassin.mp3' }
      let(:malicious_media2) { "Free' Falling.mp3" }
      let(:malicious_media3) { 'Free" Falling.mp3' }
      it 'escapes them' do
        subject.add(malicious_media)
        subject.media.last.should eql '\(02\)\ -\ John\ Mayer\ Assassin.mp3'
        subject.add(malicious_media2)
        subject.media.last.should eql "Free\\'\\ Falling.mp3"
        subject.add(malicious_media3)
        subject.media.last.should eql 'Free\"\\ Falling.mp3'
      end
    end
  end

  context '#shuffle' do
    it 'readjusts the current_index to the current_media' do
      current_media = subject.current_media
      subject.shuffle
      subject.current_media.should eql current_media
    end
    it {
      subject.media.should_receive(:shuffle!).with(no_args())
      subject.shuffle
    }
  end

  context '#current_media' do
    it { subject.current_media.should eql 'a.mp3' }
  end

  context '#next_media' do
    it { subject.next_media.should eql 'b.wav' }

    context 'when end of playlist is reached' do
      before { subject.current_index = subject.media.size - 1 }
      # TODO: shuffle automatically on next loop?
      it { subject.next_media.should eql 'a.mp3' }
    end
  end

  context '#previous_media' do
    before { subject.current_index = 1 }
    it { subject.previous_media.should eql 'a.mp3' }

    context 'when beginning of playlist is reached' do
      before { subject.current_index = 0 }
      it { subject.previous_media.should eql 'd.wav' }
    end
  end
end
