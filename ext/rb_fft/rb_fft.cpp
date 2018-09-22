#include "rb_fft.h"

VALUE rb_mRbFFT;

VALUE hello(VALUE _self) {
  return Qtrue;
}

extern "C" void Init_rb_fft(void)
{
  rb_mRbFFT = rb_define_module("RbFFT");
  rb_define_module_function(rb_mRbFFT, "hello", (VALUE(*)(ANYARGS)) hello, 0);
}
