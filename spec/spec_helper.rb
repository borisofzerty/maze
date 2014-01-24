require_relative '../maze.rb'
$LOAD_PATH << File.join(File.dirname(__FILE__), '..')

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true
end
