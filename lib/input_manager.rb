require 'forwardable'

module MediaPlayer
  class InputManager
    extend Forwardable
    # Shortcuts? maybe
    # SHORTCUTS = %w(a sh pl st pa n pr e)
    # SHORTCUT_MAPPINGS = {
    #   'a' => 'add',
    #   'sh' => 'shuffle',
    #   'pl' => 'play',
    #   'st' => 'stop',
    #   'pa' => 'pause',
    #   'n' => 'next',
    #   'pr' => 'prev',
    #   'e' => 'exit'
    # }
    INSTRUCTIONS = %w(add shuffle play stop pause next prev exit)
    attr_reader :player
    def_delegators :@player, :shuffle, :play, :stop, :pause, :next
    def_delegator :@player, :previous, :prev

    def initialize(args={})
      @player = args.fetch(:player)
    end

    def process(instruction)
      if INSTRUCTIONS.include? instruction.split(' ').first
        begin
          if instruction.match(/add/)
            path = (instruction.split(' ') - ['add']).join(' ')
            type = File.ftype(path)
            if type == 'directory'
              Dir.glob("#{path}/*.mp3") { |file| @player.add_media(file) }
            elsif type == 'file'
              @player.add_media(path)
            end
          else
            send instruction
          end
        rescue => e
          return e.message
        end
      else
        return 'Invalid Instruction'
      end
    end

    # TODO: The only thing not covered by test
    def start
      while (input = gets.chomp) != 'exit'
        p process(input)
      end
      p process('stop')
    end
  end
end

