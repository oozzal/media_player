require 'media_player/version'
require_relative './process_manager'
require_relative './playlist'
require 'forwardable'

module MediaPlayer
  class Player
    extend Forwardable
    attr_reader :process_manager, :playlist, :is_active
    attr_accessor :repeat, :is_active
    def_delegators :@playlist, :current_media, :next_media, :previous_media, :shuffle

    def initialize(media = [])
      @process_manager = MediaPlayer::ProcessManager.new
      @repeat = false
      @playlist = MediaPlayer::PlayList.new(media)
    end

    def add_media(media_file)
      @playlist.add(media_file)
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

    def shuffle=(value)
      @shuffle = value
      @playlist.shuffle if value
    end

  end
end
