#include "rb_fft.h"

VALUE rb_mRbFFT;

void
Init_rb_fft(void)
{
  rb_mRbFFT = rb_define_module("RbFFT");
}
