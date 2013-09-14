require_relative '../spec_helper'

describe 'An instance of InputManager', MediaPlayer::InputManager do
  subject { MediaPlayer::InputManager.new }

  it 'has instructions and options' do
    MediaPlayer::InputManager::INSTRUCTIONS.should_not be_nil
  end

  it { subject.player.should_not be_nil }

  context '#process' do
    context 'when instruction is invalid' do
      it {
        return_value = subject.process('hawa jpt')
        return_value.should eql 'Invalid Instruction'
      }
    end

    context 'when instruction is valid' do
      context 'when add' do
        context 'when adding directory' do
          it {
            dir = '/Users/uzzaldevkota/Music/Selected Music'
            File.stub(:ftype).and_return 'directory'
            search = "#{dir}/*.mp3"
            Dir.should_receive(:glob).with(search)
            subject.process("add #{dir}")
          }
        end
        context 'when adding file' do
          it {
            file = '/Users/uzzaldevkota/Music/John Lennon imagine.mp3'
            File.stub(:ftype).and_return 'file'
            subject.player.should_receive(:add_media).with(file)
            subject.process("add #{file}")
          }
        end
      end

      context 'when shuffle' do
        it {
          subject.player.should_receive(:shuffle).with(no_args())
          subject.process('shuffle')
        }
      end

      context 'when play' do
        it {
          subject.player.should_receive(:play).with(no_args())
          subject.process('play')
        }
      end

      context 'when stop' do
        it {
          subject.player.should_receive(:stop).with(no_args())
          subject.process('stop')
        }
      end

      context 'when pause' do
        it {
          subject.player.should_receive(:pause).with(no_args())
          subject.process('pause')
        }
      end

      context 'when next' do
        it {
          subject.player.should_receive(:next).with(no_args())
          subject.process('next')
        }
      end

      context 'when prev' do
        it {
          subject.player.should_receive(:previous).with(no_args())
          subject.process('prev')
        }
      end
    end
  end

end
