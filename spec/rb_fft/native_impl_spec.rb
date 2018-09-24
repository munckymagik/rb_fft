RSpec.describe RbFFT::NativeImpl do
  it 'is a module under RbFFT' do
    expect(RbFFT::NativeImpl).to be_a_kind_of(Module)
  end

  it_behaves_like 'an FFT implementation'
end
