require 'media_player/version'
require_relative './process_manager'
require_relative './playlist'

module MediaPlayer
  class Player
    attr_accessor :process_manager, :playlist, :shuffle, :repeat, :is_active
    def initialize(media = [])
      @process_manager = MediaPlayer::ProcessManager.new
      @shuffle = false
      @repeat = false
      @playlist = MediaPlayer::PlayList.new(media)
    end

    def add_media(media_file)
      @playlist.add(media_file)
    end

    def current_media
      @playlist.current_media rescue nil
    end

    def next_media
      @playlist.next_media(@shuffle) rescue nil
    end

    def previous_media
      @playlist.previous_media(@shuffle) rescue nil
    end

    def play
      if @is_active
        @process_manager.resume
      else
        @is_active = true
        @process_manager.execute(current_media)
      end
    end

    def stop
      @is_active = false
      @process_manager.stop
    end

    def pause
      @process_manager.pause
    end

    def next
      @process_manager.execute(next_media)
    end

    def previous
      @process_manager.execute(previous_media)
    end

    def toggle_shuffle
      @shuffle = @shuffle ? false : true
    end

    def toggle_repeat
      @repeat = @repeat ? false : true
    end
  end
end
