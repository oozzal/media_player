# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'media_player/version'

Gem::Specification.new do |spec|
  spec.name          = "media_player"
  spec.version       = MediaPlayer::VERSION
  spec.authors       = ["oozzal"]
  spec.email         = ["theoozzal@gmail.com"]
  spec.description   = %q{Command line media player.}
  spec.summary       = %q{Plays media files right from the command line giving some basic media controls.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
