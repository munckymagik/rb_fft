#include "rb_fft.h"
#include "fft.h"

#include <complex>

using std::complex;

static ID idComplex;
static ID idReal;
static ID idImag;

static VALUE NativeImpl_fft(VALUE _self, VALUE rb_samples) {
  // Checks we have been passed an array or raises a TypeError
  Check_Type(rb_samples, T_ARRAY);

  const long samples_len = RARRAY_LEN(rb_samples);

  if (samples_len <= 1) {
    return rb_samples;
  }

  // NOTE memory malloc'd here
  complex<double> *samples = new complex<double>[samples_len];

  // Marshall Ruby input into C++
  for (long i = 0; i < samples_len; ++i) {
    // Fetch a element from the array
    VALUE elem = rb_ary_entry(rb_samples, i);

    // The element must be of Ruby type Complex
    if (!RB_TYPE_P(elem, T_COMPLEX)) {
      rb_raise(rb_eArgError, "array elements must be Complex numbers");

      // NOTE memory freed here
      delete[] samples;
    }

    // Call accessors on the Complex to fetch the two components
    VALUE rb_real = rb_funcall(elem, idReal, 0);
    VALUE rb_imag = rb_funcall(elem, idImag, 0);

    // Convert Ruby values to C data
    double real =  NUM2DBL(rb_real);
    double imag =  NUM2DBL(rb_imag);

    // Convert to complex<T> then add to the array
    samples[i] = complex<double>(real, imag);
  }

  // Do FFT calculation here NOTE mutates input!
  fft2(samples, samples_len);

  // TODO pre-allocate as we know the size
  VALUE rb_result = rb_ary_new();

  // Marshall C++ state into Ruby output
  for (long i = 0; i < samples_len; ++i) {
    // Get the native complex
    complex<double> c = samples[i];

    // Convert data to a Ruby representation
    VALUE rb_real = DBL2NUM(c.real());
    VALUE rb_imag = DBL2NUM(c.imag());

    // Create a Ruby Complex. It has a private constructor we must call the
    // global function `Complex(...)` to construct a new instance
    // TODO can this raise?
    VALUE rb_cmpx = rb_funcall(rb_mKernel, idComplex, 2, rb_real, rb_imag);

    // Push into the result array
    rb_ary_push(rb_result, rb_cmpx);
  }

  // NOTE memory freed here
  delete[] samples;

  return rb_result;
}

void Init_RbFFT_NativeImpl(VALUE mRbFFT) {
  VALUE mRbFFTNativeImpl = rb_define_module_under(mRbFFT, "NativeImpl");
  rb_define_module_function(mRbFFTNativeImpl, "fft", RUBY_METHOD_FUNC(NativeImpl_fft), 1);

  // Fetch Ruby symbols we will need when calling methods
  idComplex = rb_intern("Complex");
  idReal = rb_intern("real");
  idImag = rb_intern("imag");
}
