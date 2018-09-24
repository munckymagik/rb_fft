//
// This file contains an implementation of the Cooley-Tukey "Fast Fourier Transform" (FFT)
// algorithm, and is based on example code from:
//     https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm
//

#include "cooley_tukey.h"

using std::complex;

// separate even/odd elements to lower/upper halves of the array respectively.
static void separate(complex<double> *a, const long n) {
    complex<double>* b = new complex<double>[n/2]; // get temp heap storage
    for (long i = 0; i < n / 2; i++)
        b[i] = a[i * 2 + 1]; // copy all the odd elements to temp
    for (long i = 0; i < n / 2; i++)
        a[i] = a[i * 2];     // copy all the evens to the lower-half of a[]
    for (long i = 0; i < n / 2; i++)
        a[n / 2 + i] = b[i]; // copy all odd (from heap) upper-half of a[]
    delete[] b;
}

// N input samples in X[] are FFT'd and the results are left in X[].
//
// Because of Nyquist theorem, N samples means only first N/2 FFT results in X[] are the answer.
// The upper half of X[] is a reflection of the lower with no new information.
//
// N must be a power-of-2, or bad things will happen. Currently there is no check for this condition.
void cooley_tukey::fft_in_place(complex<double> *X, const long N) {
    if (N < 2) {
        // bottom of recursion.
        // Do nothing here, because already X[0] = x[0]
    } else {
        separate(X, N); // all evens to lower half, all odds to upper half
        fft_in_place(X, N / 2); // recurse even items
        fft_in_place(X + N/2, N / 2); // recurse odd items

        // combine results of two half recursions
        for (long k = 0; k < N / 2; k++) {
            // w is the "twiddle-factor" and could be pre-computed
            complex<double> w = exp(complex<double>(0, -2. * M_PI * k / N));

            complex<double> e = X[k]; // even
            complex<double> o = X[k + N / 2]; // odd

            X[k] = e + w * o;
            X[k+N/2] = e - w * o;
        }
    }
}
