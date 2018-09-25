RSpec.describe RbFFT::CLI do
  describe '.main' do
    let(:stream) { StringIO.new }
    let(:exec!) { described_class.main(args, stream) }
    let(:exit_code) { exec! }
    subject { exec!; stream.string }

    context 'when passed --version' do
      let(:args) { ['--version'] }
      it { is_expected.to match(/^v#{RbFFT::VERSION}/) }
      specify { expect(exit_code).to eq(0) }
    end

    context 'when passed no arguments' do
      let(:args) { [] }
      it { is_expected.to match(/RbFFT::NativeImpl 32 \[2, 5, 11, 17, 29\]/) }
      specify { expect(exit_code).to eq(0) }
    end

    context 'when passed the --engine option' do
      let(:args) { ['--engine', 'ruby'] }
      it { is_expected.to match(/RbFFT::RubyImpl 32 \[2, 5, 11, 17, 29\]/) }
      specify { expect(exit_code).to eq(0) }
    end

    context 'when passed the --samples option' do
      let(:args) { ['--samples', '4'] }
      it { is_expected.to match(/RbFFT::NativeImpl 4 \[2, 5, 11, 17, 29\]/) }
      specify { expect(exit_code).to eq(0) }
    end

    context 'when passed the --freqs option' do
      let(:args) { ['--freqs', '1,3,5'] }
      it { is_expected.to match(/RbFFT::NativeImpl 32 \[1, 3, 5\]/) }
      specify { expect(exit_code).to eq(0) }
    end
  end
end
