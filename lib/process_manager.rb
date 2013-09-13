module MediaPlayer
  # execute, stop, pause, resume
  class ProcessManager
    attr_accessor :current_process_id

    def build_process(media_file)
      Process.spawn("play #{media_file}")
    end

    def execute(media_file)
      @current_process_id = build_process(media_file)
    end

    def pause
      Process.kill(:STOP, @current_process_id)
    end

  end
end
