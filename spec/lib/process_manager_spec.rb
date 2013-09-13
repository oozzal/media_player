require_relative '../spec_helper'

describe 'An Instance of ProcessManager', MediaPlayer::ProcessManager do
  let(:sample_media) { 'imagine.mp3' }
  let(:sample_pid) { 123 }
  let(:play_command) { "play #{sample_media}" }
  subject { MediaPlayer::ProcessManager.new }
  it { subject.current_process_id.should be_nil }

  context '#execute' do
    before { Process.stub(:spawn).and_return(sample_pid) }
    it 'plays the given media' do
      Process.should_receive(:spawn).with(play_command)
      subject.execute(sample_media)
      subject.current_process_id.should eql sample_pid
    end
  end

  context 'when manipulating current process' do
    before { subject.current_process_id = sample_pid }
    context '#pause' do
      it 'pauses the given media' do
        Process.should_receive(:kill).with(:STOP, sample_pid)
        subject.pause
      end
    end

    context '#resume' do
      it 'resumes the paused media' do
        Process.should_receive(:kill).with(:CONT, sample_pid)
        subject.resume
      end
    end

    context '#stop' do
      it 'stops the current media' do
        Process.should_receive(:kill).with(:INT, sample_pid)
        Process.should_receive(:waitpid).with(sample_pid)
        subject.stop
      end
    end
  end

end
