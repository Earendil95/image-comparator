require 'chunky_png'
require 'pathname'

class SizesMismatchError < RuntimeError
end

module ImageComparator
  MODES = {
    rgb: 'RGB',
    delta: 'Delta',
    grayscale: 'Grayscale'
  }

  require './base'
  require './image'

  def self.compare(expected_path, test_path, mode = :rgb)
    raise ArgumentError.new("Undefined mode '#{ mode }'") unless MODES.include?(mode)

    expected, test = Image.from_file(expected_path), Image.from_file(test_path)

    raise SizesMismatchError.new("\nSize mismatch: expected size: #{ expected.width }x#{ expected.height }\n" \
                                  "                   test size: #{ test.width }x#{ test.height }") unless expected.sizes_match?(test)

    result = comparison_mode(mode).new(expected, test)
    result.compare
  end

  def self.comparison_mode(mode)
    ImageComparator.const_get(MODES[mode])
  end
end

res = ImageComparator.compare('./spec/fixtures/a.png', './spec/fixtures/darker.png', :delta)
p res.score
res.save_difference_image './black.png'
