RSpec.describe RbFFT::RubyImpl do
  it_behaves_like 'an FFT implementation'

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
