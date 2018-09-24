RSpec.shared_examples 'an FFT implementation' do
  subject { super() || (raise 'please define `subject` as the module containing the algorithm') }

  describe '.fft' do
    context 'when passed something other than an array' do
      it 'raises TypeError' do
        expect {
          subject.fft(nil)
        }.to raise_error(TypeError, /expected Array/)
      end
    end

    context 'when passed an empty array' do
      it 'returns an empty array' do
        expect(subject.fft([])).to eq([])
      end
    end

    context 'when passed an array not containing complex numbers' do
      it 'raises an argument error' do
        expect{
          subject.fft([1.0.to_c, 2.0])
        }.to raise_error(ArgumentError, "array elements must be Complex numbers")
      end
    end

    context 'the base case: when input size is 1' do
      it 'does nothing' do
        xs = RbFFT::SignalGen.gen([1], 1)
        ys = subject.fft(xs)
        expect(ys).to eq(xs)
      end
    end

    it 'identifies frequencies in a set of samples' do
      samples = RbFFT::SignalGen.gen([2, 5, 11, 17, 29], 64)

      results = subject.fft(samples)

      expect(results.length).to eq(64)
      expect(results).to all(be_a(Complex))

      results = results.map { |x| x.abs.floor }

      # These indices in the result should contain non-zero values and thus mark the frequencies
      # the algorithm has identified
      freq_indices = [2, 5, 11, 17, 29, 62, 59, 53, 47, 35]

      # The indexes corresponding to the identified frequencies will = 32 = n/2
      expect(results.values_at(*freq_indices)).to all(eq(32))

      # All other indices will be 0
      expect(results.reject.with_index { |_, i| freq_indices.include?(i) }).to all(eq(0))
    end
  end
end
