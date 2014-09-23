require_relative '../spec_helper'

describe 'An Instance of Player', MediaPlayer::Player do
  let(:sample_media) { 'imagine.mp3' }
  let(:media) { [] }
  let(:process_manager) { double('process_manager') }
  let(:playlist) {
    double(
      'playlist',
      media: media,
      current_media: nil, next_media: nil,
      previous_media: nil, shuffle: nil
    )
  }

  # Beware, error in testing observe method
  # before { MediaPlayer::Player.any_instance.stub(:observe) }
  subject {
    MediaPlayer::Player.new(
      process_manager: process_manager,
      playlist: playlist
    )
  }

  it { expect(subject.is_playing).to eql false }
  it { expect(subject.paused).to eql false }

  # Delegated methods
  it 'responds to delegated methods' do
    expect(subject).to respond_to(:current_process_id)
    expect(subject).to respond_to(:media)
    expect(subject).to respond_to(:current_media)
    expect(subject).to respond_to(:next_media)
    expect(subject).to respond_to(:previous_media)
    expect(subject).to respond_to(:shuffle)
  end

  it { expect(subject.media).to eql [] }

  describe '#add_media' do
    it 'pushes media to the playlist' do
      expect(subject.playlist).to receive(:add).with sample_media
      subject.add_media sample_media
    end
  end

  context 'when initialized with some media' do
    before { allow(subject.playlist).to receive(:current_media).and_return sample_media }
    let(:media) { ['a.mp3', 'b.wav'] }
    it { expect(subject.playlist).not_to eql nil }

    describe '#play' do
      context 'when player is not playing any media' do
        it 'plays the media in the playlist' do
          expect(subject.process_manager).to receive(:execute).with sample_media
          expect(subject).to receive(:observe).with no_args
          subject.play
        end

        context 'when player has paused some media' do
          before { subject.instance_variable_set('@paused', true) }
          it 'resumes the paused media' do
            expect(subject.process_manager).to receive(:resume).with no_args
            subject.play
          end
        end
      end
    end

    describe '#stop' do
      it 'stops the current media' do
        expect(subject.process_manager).to receive(:stop).with no_args
        subject.stop
        expect(subject.is_playing).to eql false
      end
    end

    describe '#pause' do
      it 'pauses the currently playing media from the playlist' do
        expect(subject.process_manager).to receive(:pause).with no_args
        subject.pause
      end
    end

    describe '#next' do
      it 'plays the next media from the playlist' do
        expect(subject.playlist).to receive(:next_media).and_return sample_media
        expect(subject.process_manager).to receive(:stop).with no_args
        expect(subject.process_manager).to receive(:execute).with sample_media
        subject.next
      end
    end

    describe '#previous' do
      it 'plays the previous media in the playlist' do
        expect(subject.playlist).to receive(:previous_media).and_return sample_media
        expect(subject.process_manager).to receive(:stop).with no_args
        expect(subject.process_manager).to receive(:execute).with sample_media
        subject.previous
      end
    end
  end
end

