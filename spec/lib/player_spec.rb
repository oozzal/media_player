require_relative '../spec_helper'

describe 'An Instance of Player', MediaPlayer::Player do
  let(:sample_media) { 'imagine.mp3' }
  subject { MediaPlayer::Player.new }

  it { subject.is_active.should eql nil }
  it { subject.process_manager.should_not be_nil }
  it { subject.repeat.should eql false }

  context 'when initialized without any media' do
    it { subject.playlist.media.should be_empty }
    it { subject.current_media.should be_nil }
    it { subject.next_media.should be_nil }
  end

  context 'when adding media' do
    it 'pushes media to the playlist' do
      subject.playlist.should_receive(:add).with(sample_media)
      subject.add_media(sample_media)
    end
  end

  context 'when initialized with some media' do
    let(:player) { MediaPlayer::Player.new(['a.mp3', 'b.wav']) }
    it { player.playlist.should_not be_nil }

    it '#current_media' do
      player.playlist.should_receive(:current_media).with(no_args())
      player.current_media
    end

    it '#next_media' do
      player.playlist.should_receive(:next_media).with(no_args())
      player.next_media
    end

    it '#previous_media' do
      player.playlist.should_receive(:previous_media).with(no_args())
      player.previous_media
    end

    it '#shuffle' do
      player.playlist.should_receive(:shuffle).with(no_args())
      player.shuffle
    end

    context 'when setting repeat' do
      it {
        player.repeat = true
        player.repeat.should eql true
      }
      it {
        player.repeat = false
        player.repeat.should eql false
      }
    end

    context 'when manipulating media' do
      context 'when manipulating current media' do
        before { player.playlist.stub(:current_media).and_return(sample_media) }
        context 'when playing media' do
          context 'when player is not active' do
            it 'plays the media in the playlist' do
              player.process_manager.should_receive(:execute).with(sample_media)
              return_value = player.play
              expect(return_value.include? sample_media).to be_true
              player.is_active.should eql true
            end
          end

          context 'when player is active' do
            before { player.instance_variable_set('@is_active', true) }
            it 'resumes the paused media' do
              player.process_manager.should_receive(:resume).with(no_args())
              return_value = player.play
              expect(return_value.include? sample_media).to be_true
            end
          end
        end

        context 'when stopping media' do
          it 'stops the current media' do
            player.process_manager.should_receive(:stop).with(no_args())
            return_value = player.stop
            expect(return_value.include? sample_media).to be_true
            player.is_active.should eql false
          end
        end

        context 'when pausing media' do
          it 'pauses the currently playing media from the playlist' do
            player.process_manager.should_receive(:pause).with(no_args())
            return_value = player.pause
            expect(return_value.include? sample_media).to be_true
          end
        end

      end

      context 'when changing media' do
        context '#next' do
          it 'plays the next media from the playlist' do
            player.playlist.stub(:next_media).and_return(sample_media)
            player.process_manager.should_receive(:stop).with(no_args())
            player.process_manager.should_receive(:execute).with(sample_media)
            return_value = player.next
            expect(return_value.include? sample_media).to be_true
          end
        end

        context '#previous' do
          it 'plays the previous media in the playlist' do
            player.playlist.stub(:previous_media).and_return(sample_media)
            player.process_manager.should_receive(:stop).with(no_args())
            player.process_manager.should_receive(:execute).with(sample_media)
            return_value = player.previous
            expect(return_value.include? sample_media).to be_true
          end
        end
      end
    end
  end

end
