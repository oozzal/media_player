module MediaPlayer
  class PlayList
    attr_accessor :media, :played_media, :current_index
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

    # Update both @media and @played_media
    def update_media
      @played_media << @media.delete_at(@current_index)
    end

    def next_media(shuffle)
      if shuffle
        if @media.empty?
          @media = @played_media.dup
          @played_media = []
        end
        @current_index = @media.index(@media.sample)
      else
        @current_index += 1
        @current_index = 0 if @media.size == @current_index
      end
      media_to_return = current_media
      update_media
      media_to_return
    end
  end
end
