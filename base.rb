module ImageComparator
	class Base
		require './modes/rgb'
		require './modes/delta'
		require './modes/grayscale'

		include ChunkyPNG::Color

		attr_reader :result

		class CompareResult
			include ChunkyPNG::Color

			attr_accessor :diff, :score

			def initialize(size, mode)
				@score = 0.0
				@diff = Array.new
				@size = size
				@mode = mode
			end 

			def save_difference_image(path)
				make_path(path)
				@mode.save_diff(@size, @diff, path)
			end

			private 

			def make_path(path)
				path = Pathname.new(path)
				path.dirname.mkpath unless path.dirname.exist?
				path.unlink if path.exist?
			end
		end

		def initialize(expected, test)
			@expected = expected
			@test = test
			@result = CompareResult.new({ width: @expected.width, height: @expected.height }, self.class)
		end

		def compare
      @test.compare_each_pixel(@expected) do |test_pixel, expected_pixel, x, y|
        next if pixels_equal?(test_pixel, expected_pixel)
        @result.diff << [test_pixel, expected_pixel, x, y]
      end

      @result.score = score
      @result
		end
	end
end
