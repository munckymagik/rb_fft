
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rb_fft/version"

Gem::Specification.new do |spec|
  spec.name          = "rb_fft"
  spec.version       = RbFFT::VERSION
  spec.authors       = ["Dan Munckton"]
  spec.email         = ["dangit@munckfish.net"]

  spec.summary       = 'The Cooley-Tukey FFT algorithm in Ruby and C++'
  spec.description   = 'An experiment which implements the Cooley-Tukey FFT algorithm in Ruby and C++ to compare speed'
  spec.homepage      = 'https://github.com/munckymagik/rb_fft'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # I don't want to publish this (cannot be nil, must be a string)
    spec.metadata["allowed_push_host"] = ''
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/rb_fft/extconf.rb"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "rspec", "~> 3.0"
end
