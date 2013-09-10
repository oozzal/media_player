require 'media_player/version'
require_relative './process_manager'
require_relative './PlayList'

module MediaPlayer
  class Player
    attr_accessor :process_manager, :playlist, :shuffle, :repeat
    def initialize(media = [])
      @process_manager = MediaPlayer::ProcessManager.new
      @shuffle = false
      @repeat = false
      @playlist = MediaPlayer::PlayList.new(media) unless media.empty?
    end

    def play
      @playlist.play
    end

    def next
      @playlist.next
    end

    def toggle_shuffle
      @shuffle = @shuffle ? false : true
    end

    def toggle_repeat
      @repeat = @repeat ? false : true
    end

  end
end
