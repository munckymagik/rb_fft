require 'mkmf'

$CXXFLAGS += " -std=c++14 -Wno-deprecated-register "

create_makefile('rb_fft/rb_fft')
