RSpec.describe RbFFT::CLI do
  describe '.main' do
    subject { described_class.main(args) }

    context 'when passed --version' do
      let(:args) { ['--version'] }
      specify { expect { subject }.to output(/^v#{RbFFT::VERSION}/).to_stdout }
      it { is_expected.to eq(0) }
    end

    context 'when passed no arguments' do
      let(:args) { [] }
      specify { expect { subject }.to output(/RbFFT::NativeImpl 32 \[2, 5, 11, 17, 29\]/).to_stdout }
      it { is_expected.to eq(0) }
    end

    context 'when passed the --engine option' do
      let(:args) { ['--engine', 'ruby'] }
      specify { expect { subject }.to output(/RbFFT::RubyImpl 32 \[2, 5, 11, 17, 29\]/).to_stdout }
      it { is_expected.to eq(0) }
    end

    context 'when passed the --samples option' do
      let(:args) { ['--samples', '4'] }
      specify { expect { subject }.to output(/RbFFT::NativeImpl 4 \[2, 5, 11, 17, 29\]/).to_stdout }
      it { is_expected.to eq(0) }
    end

    context 'when passed the --freqs option' do
      let(:args) { ['--freqs', '1,3,5'] }
      specify { expect { subject }.to output(/RbFFT::NativeImpl 32 \[1, 3, 5\]/).to_stdout }
      it { is_expected.to eq(0) }
    end
  end
end
