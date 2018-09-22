RSpec.describe RbFFT::SignalGen do
  it 'generates a signal for the requested frequencies and number of samples' do
    samples = described_class.gen([2, 5, 11, 17, 29], 64)
    expect(samples.length).to eq(64)
    expect(samples).to all(be_a(Complex))
    puts samples.inspect
  end
end
