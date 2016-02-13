require 'chunky_png'
require 'pathname'

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
		raise ArgumentError.new("Cannot load such file: '#{ expected_path }'") unless Pathname.new(expected_path).exist?
		raise ArgumentError.new("Cannot load such file: '#{ test_path }'") unless Pathname.new(test_path).exist?

		klass = ImageComparator.const_get(MODES[mode])
		expected = Image.from_file(expected_path)
		test = Image.from_file(test_path)

		raise "\nSize mismatch: expected size: #{ expected.width }x#{ expected.height }\n" \
					"                   test size: #{ test.width }x#{ test.height }" unless expected.sizes_match?(test)

		result = klass.new(expected, test)
		result.compare
	end
end

res = ImageComparator.compare('./spec/fixturess/grayscale_a.png', './spec/fixtures/grayscale_b.png')
res.save_difference_image './black.png'
