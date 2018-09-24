module RbFFT
  # Module pre-definition
end

require "rb_fft/rb_fft"
require "rb_fft/ruby_impl"
require "rb_fft/signal_gen"
require "rb_fft/version"

# Must come last as it depends on all of the above
require "rb_fft/cli"
