#include "rb_fft.h"

extern "C" void Init_rb_fft(void)
{
  VALUE mRbFFT = rb_define_module("RbFFT");
  Init_RbFFT_NativeImpl(mRbFFT);
}
