RSpec.shared_examples 'an FFT implementation' do
  subject { super() || (raise 'please define `subject` as the module containing the algorithm') }

  describe '.fft' do
    context 'when passed something other than an array' do
      it 'raises TypeError' do
        expect do
          subject.fft(nil)
        end.to raise_error(TypeError, /expected Array/)
      end
    end

    context 'when passed an array not containing complex numbers' do
      it 'raises an argument error' do
        expect do
          subject.fft([1.0.to_c, 2.0])
        end.to raise_error(ArgumentError, 'array elements must be Complex numbers')
      end
    end

    context 'when input array size is not a power of 2' do
      let(:powers_of_2) { 4.times.map { |exp| 2**exp } }
      let(:non_powers_of_2) { (0...powers_of_2.last).to_a - powers_of_2 }

      it 'raises an argument error' do
        non_powers_of_2.each do |n|
          xs = RbFFT::SignalGen.gen([1], n)
          expect { subject.fft(xs) }
            .to raise_error(ArgumentError, 'array size must be a power of 2')
        end

        powers_of_2.each do |_n|
          xs = RbFFT::SignalGen.gen([1], 2)
          expect { subject.fft(xs) }.not_to raise_error
        end
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
