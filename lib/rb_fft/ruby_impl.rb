module RbFFT
  module RubyImpl
    def self.fft(complex_samples)
      complex_samples
        .dup
        .tap { |copy| fft_inplace!(copy) }
    end

    def self.fft_inplace!(xs, offset = 0, n = xs.length)
      return if n < 2

      half_n = n / 2

      separate_inplace!(xs, offset, n)
      fft_inplace!(xs, offset, half_n)
      fft_inplace!(xs, offset + half_n, half_n)

      (0...half_n).each do |k|
        # w is the "twiddle-factor" and I think this can be pre-computed
        w = Math::E ** Complex(0.0, -2.0 * Math::PI * k / n)

        e = xs[offset + k]          # even
        o = xs[offset + k + half_n] # odd

        xs[offset + k]          = e + w * o;
        xs[offset + k + half_n] = e - w * o;
      end
    end

    # Separates in-place even/odd elements to lower/upper halves of the array
    # ATTENTION operates "in-place" - it mutates arr
    def self.separate_inplace!(arr, offset = 0, n = arr.length)
      raise ArgumentError, "n isn't a multiple of 2" if n % 2 != 0

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
  end
end
