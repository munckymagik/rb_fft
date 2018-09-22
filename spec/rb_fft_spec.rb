RSpec.describe RbFFT do
  it "has a version number" do
    expect(RbFFT::VERSION).not_to be nil
  end

  it 'can call hello in C++' do
    expect(described_class.hello).to be(true)
  end
end
