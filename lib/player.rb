require_relative './media_player/version'
require 'forwardable'

module MediaPlayer
  class Player
    extend Forwardable
    attr_reader :process_manager, :playlist, :is_playing, :paused
    def_delegator :@process_manager, :current_process_id
    def_delegators :@playlist, :media, :current_media, :next_media, :previous_media, :shuffle

    def initialize(args = {})
      @process_manager = args.fetch(:process_manager)
      @playlist = args.fetch(:playlist)
      @is_playing = false
      @paused = false
    end

    def add_media(media_file)
      @playlist.add(media_file)
    end

    def play
      return if @is_playing
      if @paused
        @paused = false
        @process_manager.resume
      else
        @is_playing = true
        @process_manager.execute(current_media)
      end
      observe
    end

    def stop
      @is_playing = false
      @process_manager.stop
    end

    def pause
      @is_playing = false
      @paused = true
      @process_manager.pause
    end

    def next
      @process_manager.stop
      @process_manager.execute(next_media)
    end

    def previous
      @process_manager.stop
      @process_manager.execute(previous_media)
    end

    def observe
      Thread.new do
        while @is_playing
          self.next unless @process_manager.is_current_process_alive?
          sleep 2
        end
      end
    end

  end
end

