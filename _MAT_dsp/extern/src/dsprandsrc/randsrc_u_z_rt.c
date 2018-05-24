/*
 *  randsrc_u_z_rt.c
 *  DSP Random Source Run-Time Library Helper Function
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#ifdef MW_DSP_RT
#include "src/dsprandsrc64bit_rt.h"
#include "src/dspendian_rt.h"
#else
#include "dsprandsrc64bit_rt.h"
#include "dspendian_rt.h"
#endif

#if (!defined(INTEGER_CODE) || !INTEGER_CODE) && defined(CREAL_T)

#include <math.h>

LIBMW_SRC_API void MWDSP_RandSrc_U_Z(creal64_T *y,    /* output signal */
                       const real64_T *min,   /* vector of mins */
                       int_T minLen,    /* length of min vector */
                       const real64_T *max,   /* vector of maxs */
                       int_T maxLen,    /* length of max vector */
                       real64_T *state, /* state vectors */
                       int_T nChans,    /* number of channels */
                       int_T nSamps)    /* number of samples per channel */
{
    union  {
        real64_T dp;
        struct { int32_T top; int32_T bot;} sp;
    } r;
    /* Treat real and imag parts as separate samples; that is,
     * samps = 2*nSamps, fill real and imag parts of output separately
     * Min and max vector elements apply to both parts.  For example,
     * min = 2, max = 6 defines the rectangle with lower left (2+2i) and
     * upper right (6+6i)
     */
    int_T newNSamps = 2*nSamps;
    real64_T *yPtr = (real64_T*)y;

    while (nChans--) {
        uint32_T i = ((uint32_T) state[33])&31;
        uint32_T j = (uint32_T) state[34];
        int_T samps = newNSamps;
        real64_T scale = *max - *min;

        while (samps--) {
            /* "Subtract with borrow" generator */
            r.dp = state[(i+20)&31] - state[(i+5)&31] - state[32];
            if (r.dp >= 0) {
                state[32] = 0;
            } else {
                r.dp += 1.0;
                state[32] = ldexp(1.,-53);
            }
            state[i] = r.dp;
            i = (i+1)&31; /* compute (i+1) mod 32 */

            /* XOR with shift register sequence */
            if (isLittleEndian()) {
                r.sp.top ^= j;
                j ^= (j<<13); j ^= (j>>17); j ^= (j<<5);
                r.sp.bot ^= (j&0x000fffff);
            } else {
                r.sp.bot ^= j;
                j ^= (j<<13); j ^= (j>>17); j ^= (j<<5);
                r.sp.top ^= (j&0x000fffff);
            }
            *yPtr++ = (*min) + scale*(r.dp);
        }
        /* record state */
        state[33] = (real64_T) i;
        state[34] = (real64_T) j;
        /* advance state, min, max */
        state += 35;
        if (minLen > 1) min++;
        if (maxLen > 1) max++;
    }
}

#endif /* !INTEGER_CODE && CREAL_T */

/* [EOF] randsrc_u_z_rt.c */
