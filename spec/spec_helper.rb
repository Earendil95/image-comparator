require_relative '../image_comparator'
require 'rspec'
require 'fileutils'

def root
  "#{ __dir__ }/../"
end

def fixtures
  "#{ __dir__ }/fixtures/"
end

RSpec.configure do |config|
  config.after(:suite) do
    FileUtils.rm_rf root + 'tmp/spec'
  end
end
