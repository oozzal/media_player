require_relative '../spec_helper'

describe 'An Instance of Playlist', MediaPlayer::PlayList do
  subject { MediaPlayer::PlayList.new(['a.mp3', 'b.wav', 'c.mp3', 'd.wav']) }
  context 'when initialized' do
    it { expect(subject.media).not_to be_empty }
    it { expect(subject.current_index).not_to be_nil }
  end

  context '#add' do
    let(:sample_media) { 'imagine.mp3' }
    before { subject.add(sample_media) }

    it { expect(subject.media.include?(sample_media)).to eql true }

    context 'when illegal characters occur in the path to media' do
      let(:malicious_media) { '(02) - John Mayer Assassin.mp3' }
      let(:malicious_media2) { "Free' Falling.mp3" }
      let(:malicious_media3) { 'Free" Falling.mp3' }
      let(:malicious_media4) { 'Pink & Nate Reus.mp3' }

      it 'escapes them' do
        subject.add(malicious_media)
        expect(subject.media.last).to eql '\(02\)\ -\ John\ Mayer\ Assassin.mp3'
        subject.add(malicious_media2)
        expect(subject.media.last).to eql "Free\\'\\ Falling.mp3"
        subject.add(malicious_media3)
        expect(subject.media.last).to eql 'Free\"\\ Falling.mp3'
        subject.add(malicious_media4)
        expect(subject.media.last).to eql 'Pink\ \&\ Nate\ Reus.mp3'
      end
    end
  end

  context '#shuffle' do
    it 're-adjusts the current_index to the current_media' do
      current_media = subject.current_media
      subject.shuffle
      expect(subject.current_media).to eql current_media
    end

    it {
      expect(subject.media).to receive(:shuffle!).with no_args
      subject.shuffle
    }
  end

  context '#current_media' do
    it { expect(subject.current_media).to eql 'a.mp3' }
  end

  context '#next_media' do
    it { expect(subject.next_media).to eql 'b.wav' }

    context 'when end of playlist is reached' do
      before { subject.instance_variable_set('@current_index', subject.media.size - 1) }
      # TODO: shuffle automatically on next loop?
      it { expect(subject.next_media).to eql 'a.mp3' }
    end
  end

  context '#previous_media' do
    before { subject.instance_variable_set('@current_index', 1) }
    it { expect(subject.previous_media).to eql 'a.mp3' }

    context 'when beginning of playlist is reached' do
      before { subject.instance_variable_set('@current_index', 0) }
      it { expect(subject.previous_media).to eql 'd.wav' }
    end
  end
end

