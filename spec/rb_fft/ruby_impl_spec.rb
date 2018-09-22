RSpec.describe RbFFT::RubyImpl do
  describe '.fft' do
    context 'the base case: when input size is 1' do
      it 'does nothing' do
        xs = RbFFT::SignalGen.gen([1], 1)
        ys = described_class.fft(xs)
        expect(xs).to eq(ys)
      end
    end

    it 'identifies frequencies in a set of samples' do
      samples = RbFFT::SignalGen.gen([2, 5, 11, 17, 29], 64)

      results = described_class.fft(samples).map { |x| x.abs.floor }

      # These indices in the result should contain non-zero values and thus mark the frequencies
      # the algorithm has indentified
      freq_indices = [2, 5, 11, 17, 29, 62, 59, 53, 47, 35]

      # The indexes corresponding to the identified frequencies will = 32 = n/2
      expect(results.values_at(*freq_indices)).to all(eq(32))

      # All other indices will be 0
      expect(results.reject.with_index { |_, i| freq_indices.include?(i) }).to all(eq(0))
    end
  end

  describe '.separate_inplace!' do
    it 'raises if given an input that isn\'t a multiple of 2' do
      expect {
        described_class.separate_inplace!(1.times.to_a)
      }.to raise_error(ArgumentError)

      expect {
        described_class.separate_inplace!(2.times.to_a)
      }.not_to raise_error
    end

    it 'separates even/odd elements to lower/upper halves of the array' do
      expect(described_class.separate_inplace!(2.times.to_a)).to eq([0, 1])
      expect(described_class.separate_inplace!(4.times.to_a)).to eq([0, 2, 1, 3])
    end

    context 'when passed a length and an offset' do
      it 'only separates elements within the specified range' do
        expect(described_class.separate_inplace!(8.times.to_a, 4, 4)).to eq([0, 1, 2, 3, 4, 6, 5, 7])
        expect(described_class.separate_inplace!(8.times.to_a, 2, 4)).to eq([0, 1, 2, 4, 3, 5, 6, 7])
      end
    end

    it 'mutates the input array' do
      a = 2.times.to_a
      expect(described_class.separate_inplace!(a)).to be(a)
    end
  end
end
