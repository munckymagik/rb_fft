module RbFFT
  module SignalGen
    def self.gen(frequencies, num_samples)
      num_samples.times.map do |i|
        frequencies.reduce(Complex(0.0, 0.0)) do |c, freq|
          c + Math.sin(2 * Math::PI * freq * i / num_samples)
        end
      end
    end
  end
end
