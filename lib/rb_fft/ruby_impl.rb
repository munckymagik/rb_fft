module RbFFT
  module RubyImpl
    def self.fft(array_of_complex)
      raise TypeError, 'expected Array' unless array_of_complex.is_a? Array
      raise ArgumentError, 'array size must be a power of 2' \
        unless power_of_2?(array_of_complex.length)

      array_of_complex
        .dup
        .tap { |copy| fft_inplace!(copy) }
    end

    module PrivateMethods
      private

      # ATTENTION operates "in-place" - it mutates xs
      def fft_inplace!(xs, offset = 0, n = xs.length)
        # nothing to do
        return if n == 0

        # check the first element so by the time we have recursed we have checked all elements once
        raise ArgumentError, 'array elements must be Complex numbers' unless xs[offset].is_a? Complex

        # this is the base-case of the recursion so we can return and unwind
        return if n < 2

        half_n = n / 2

        separate_inplace!(xs, offset, n)
        fft_inplace!(xs, offset, half_n)
        fft_inplace!(xs, offset + half_n, half_n)

        (0...half_n).each do |k|
          # w is the "twiddle-factor" and I think this can be pre-computed
          w = Math::E**Complex(0.0, -2.0 * Math::PI * k / n)

          e = xs[offset + k]          # even
          o = xs[offset + k + half_n] # odd

          xs[offset + k]          = e + w * o
          xs[offset + k + half_n] = e - w * o
        end
      end

      # Separates in-place even/odd elements to lower/upper halves of the array
      # ATTENTION operates "in-place" - it mutates arr
      def separate_inplace!(arr, offset = 0, n = arr.length)
        raise ArgumentError, "n isn't a multiple of 2" if n.odd?

        return arr if n == 2

        # copy all the elements at odd indexes to a temp array
        tmp = arr.slice(offset, n).select.with_index { |_, i| i.odd? }

        half_n = n / 2

        # copy all the elements at even indexes to the lower-half of arr
        (0...half_n).each do |i|
          arr[offset + i] = arr[offset + i * 2]
        end

        # copy the odd elements from tmp to the upper-half of arr
        (0...half_n).each do |i|
          arr[offset + half_n + i] = tmp[i]
        end

        arr
      end

      def power_of_2?(size)
        size.positive? && (size & (size - 1)).zero?
      end
    end

    extend PrivateMethods
  end
end
