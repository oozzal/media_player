require_relative '../spec_helper'

describe 'An Instance of Playlist', MediaPlayer::PlayList do
  subject { MediaPlayer::PlayList.new(['a.mp3', 'b.wav', 'c.mp3', 'd.wav']) }
  context 'when initialized' do
    it { subject.media.should_not be_nil }
    it { subject.media.should_not be_empty }
    it { subject.played_media.should_not be_nil }
    it { subject.played_media.should be_empty }
    it { subject.current_index.should_not be_nil }
  end

  context '#add' do
    let(:sample_media) { 'imagine.mp3' }
    before { subject.add(sample_media) }
    it { expect(subject.media.include?(sample_media)).to eql true }
  end

  context '#current_media' do
    it { subject.current_media.should eql 'a.mp3' }
  end

  context '#next_media' do
    context 'when next media is returned' do
      let(:shuffle) { false }
      let(:played_media) { subject.next_media(shuffle) }
      it 'updates the media arrays' do
        subject.should_receive(:update_media)
        subject.next_media(shuffle)
      end
      it { expect(subject.media.include?(played_media)).to eql false }
      it { expect(subject.played_media.include?(played_media)).to eql true }
    end

    context 'when shuffle is off' do
      let(:shuffle) { false }
      it { subject.next_media(shuffle).should eql 'b.wav' }
      context 'when end of playlist is reached' do
        before { subject.current_index = subject.media.size - 1 }
        it { subject.next_media(shuffle).should eql 'a.mp3' }
      end
    end

    context 'when shuffle is on' do
      let(:shuffle) { true }
      let(:all_media) { subject.media + subject.played_media }
      context 'when some media are already played' do
        before do
          @played_media1 = subject.next_media(shuffle)
          @played_media2 = subject.next_media(shuffle)
        end
        it 'does not re-return them until all media are returned once' do
          subject.next_media(shuffle).should_not eql @played_media1
          subject.next_media(shuffle).should_not eql @played_media2
        end
      end

      context 'when all media are played' do
        before do
         subject.played_media = subject.media.dup
         subject.media = []
        end
        it 're-creates the media array from played_media array' do
          subject.next_media(shuffle)
          subject.media.should_not be_empty
        end
      end
    end
  end
end
