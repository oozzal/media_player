require_relative '../spec_helper'

describe 'An instance of InputManager', MediaPlayer::InputManager do
  let(:player) { double('player') }
  subject { MediaPlayer::InputManager.new player: player }

  it 'has instructions and options' do
    expect(subject.class::INSTRUCTIONS).not_to be_nil
  end

  it { expect(subject.player).not_to be_nil }

  describe '#process' do
    context 'when instruction is invalid' do
      it {
        return_value = subject.process('hawa jpt')
        expect(subject.process 'jpt').to eql 'Invalid Instruction'
      }
    end

    context 'when instruction is valid' do
      context 'when add' do
        context 'when adding directory' do
          it {
            dir = '/Users/uzzaldevkota/Music/Selected Music'
            expect(File).to receive(:ftype).and_return 'directory'
            search = "#{dir}/*.mp3"
            expect(Dir).to receive(:glob).with search
            subject.process("add #{dir}")
          }
        end
        context 'when adding file' do
          it {
            file = '/Users/uzzaldevkota/Music/John Lennon imagine.mp3'
            expect(File).to receive(:ftype).and_return 'file'
            expect(subject.player).to receive(:add_media).with file
            subject.process("add #{file}")
          }
        end
      end

      context 'when shuffle' do
        it {
          expect(subject.player).to receive(:shuffle).with no_args
          subject.process('shuffle')
        }
      end

      context 'when play' do
        it {
          expect(subject.player).to receive(:play).with no_args
          subject.process('play')
        }
      end

      context 'when stop' do
        it {
          expect(player).to receive(:stop).with no_args
          subject.process('stop')
        }
      end

      context 'when pause' do
        it {
          expect(player).to receive(:pause).with no_args
          subject.process('pause')
        }
      end

      context 'when next' do
        it {
          expect(player).to receive(:next).with no_args
          subject.process('next')
        }
      end

      context 'when prev' do
        it {
          expect(player).to receive(:previous).with no_args
          subject.process('prev')
        }
      end
    end
  end

end

