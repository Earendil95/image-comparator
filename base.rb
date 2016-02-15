module ImageComparator
  module ColorMethods
    include ChunkyPNG::Color

    def brightness(a)
      0.3 * r(a) + 0.59 * g(a) + 0.11 * b(a)
    end
  end

  class Base
    require './modes/rgb'
    require './modes/delta'
    require './modes/grayscale'

    include ColorMethods

    attr_reader :result

    class CompareResult
      include ChunkyPNG::Color

      attr_accessor :diff, :score

      def initialize(expected, mode)
        @expected = expected
        @score = 0.0
        @diff = Array.new
        @mode = mode
      end 

      def save_difference_image(path)
        make_path(path)
        @mode.save_diff(@expected, @diff, path)
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
      @result = CompareResult.new(@expected, self.class)
    end

    def compare
      @test.compare_each_pixel(@expected) do |test_pixel, expected_pixel, x, y|
        next if pixels_equal?(test_pixel, expected_pixel)
        update_result(test_pixel, expected_pixel, x, y)
      end

      @result.score = score
      @result
    end
  end
end
