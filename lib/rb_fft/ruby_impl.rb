module RbFFT
  module RubyImpl
    # Separates in-place even/odd elements to lower/upper halves of the array
    # ATTENTION operates "in-place" - it mutates arr
    def self.separate!(arr, offset = 0, n = arr.length)
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
