require_relative './media_player/version'
require_relative './playlist'
require_relative './process_manager'
require 'forwardable'

module MediaPlayer
  class Player
    extend Forwardable
    attr_reader :process_manager, :playlist, :is_active
    attr_accessor :repeat
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
        [current_media, @process_manager.resume]
      else
        @is_active = true
        [current_media, @process_manager.execute(current_media)]
      end
    end

    def stop
      @is_active = false
      [current_media, @process_manager.stop]
    end

    def pause
      [current_media, @process_manager.pause]
    end

    def next
      @process_manager.stop
      media = next_media
      [media, @process_manager.execute(media)]
    end

    def previous
      @process_manager.stop
      media = previous_media
      [media, @process_manager.execute(media)]
    end
  end
end
