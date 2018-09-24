#if !defined(FFT_H)
#define FFT_H

#include <complex>

namespace cooley_tukey {

void fft_in_place(std::complex<double> *X, const long N);

}

#endif // FFT_H
