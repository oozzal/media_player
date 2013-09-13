module MediaPlayer
  class PlayList
    attr_reader :media, :played_media
    attr_accessor :current_index

    def initialize(media)
      @media = media
      @played_media = []
      @current_index = 0
    end

    def add(media_file)
      @media.push(media_file)
    end

    def current_media
      @media[@current_index]
    end

    def next_media
      @current_index += 1
      @current_index = 0 if @media.size == @current_index
      current_media
    end

    def previous_media
      @current_index -= 1
      @current_index = @media.size - 1 if @current_index < 0
      current_media
    end

    def shuffle
      previous_current_media = current_media
      @media.shuffle!
      @current_index = @media.index(previous_current_media)
    end
  end
end
