#include "rb_fft.h"

VALUE rb_mRbFft;

void
Init_rb_fft(void)
{
  rb_mRbFft = rb_define_module("RbFft");
}
