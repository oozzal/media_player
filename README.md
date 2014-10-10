# MediaPlayer (Beta)

All in one command Line Media Player.

## Installation

Dependencies: `jruby`, [sox]( http://sox.sourceforge.net/ )

Add this line to your application's Gemfile:

    gem 'media_player'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install media_player

## Usage
  * Make sure you're using `jruby`.
  * Start the player: `player`
  * Add media: `add <filename>`
  * Play media: `play`
  * Currently supported instructions: `add shuffle play stop pause next prev exit`

## TODO
  * Tab complete instructions
  * Add more function

## Contributing

Feel free to contribute.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
