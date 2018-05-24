/*
 *  2chabank_fr_df_dd_rt.c
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 *
 * Please refer to dspfilterbank_rt.h
 * for comments and algorithm explanation.
 */

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)
#ifdef MW_DSP_RT
#include "src/dspfilterbank_rt.h"
#else
#include "dspfilterbank_rt.h"
#endif

LIBMW_SRC_API void MWDSP_2ChABank_Fr_DF_DD(
    const real_T        *u,
          real_T        *filtLongOutputBase,
          real_T        *filtShortOutputBase,
          real_T        *tap0,
          real_T        *sums,
    const real_T *const  filtLong,
    const real_T *const  filtShort,
          int32_T         *tapIdx,
          int32_T         *phaseIdx,
    const int_T          numChans,
    const int_T          inFrameSize,
    const int_T          polyphaseFiltLenLong,
    const int_T          polyphaseFiltLenShort
)
{
    const int_T filtLenLong  = polyphaseFiltLenLong  << 1;
    const int_T outFrameSize = inFrameSize           >> 1;
    const int_T leftToDo     = polyphaseFiltLenLong - polyphaseFiltLenShort;
    const int_T dFactor      = 2;

    /* initialize local variables to rid compiler warnings */
    int_T      curPhaseIdx  = *phaseIdx;
    int_T      curTapIdx    = *tapIdx;
    int_T i, k;

    /* Each channel uses the same filter phase but accesses
     * its own state memory and input.
     */
    for (k = 0; k < numChans; k++) {

        /* make per channel copies of polyphase parameters common for
           all channels */
        const real_T *cffLong      = filtLong  + *phaseIdx * polyphaseFiltLenLong;
        const real_T *cffShort     = filtShort + *phaseIdx * polyphaseFiltLenShort;
        int_T         curOutBufIdx = 0;

        curPhaseIdx  = *phaseIdx;
        curTapIdx    = *tapIdx;

        i = inFrameSize;
        while (i--) {

            /* filter current phase */
            real_T  *mem = tap0 + curTapIdx;
            int_T    j   = polyphaseFiltLenShort;

            /* read input into TapDelayBuffer which is used by both short
               and long filters */
            *mem = *u++;

            /* perform filtering on current phase
             * process filtering with both short and long filter
             * short filter output is stored in location sums
             * long filter output is stored in location (sums+1)
             */
            while (j--) {
                (*sums++) += (*mem) * (*cffShort++);    /* process short filter */
                (*sums--) += (*mem) * (*cffLong++);     /* process long  filter*/
                if ((mem-=dFactor) < tap0) mem += filtLenLong;
            }
            /* finish filtering on long filter */
            j = leftToDo;
            sums++;     /* store long filter output in location (sums+1) */
            while (j--) {
                *sums += (*mem) * (*cffLong++);
                if ((mem-=dFactor) < tap0) mem += filtLenLong;
            }
            sums--;     /* restore sums pointer for short filter output */

            /* points to next TapDelayBuffer index
               (manages input circular TapDelayBuffer) */
            if ( (++curTapIdx) >= filtLenLong ) curTapIdx = 0;

            /* increment curPhaseIdx and
             * output to OutputBuffer ONLY WHEN all polyphase filters are executed
             * i.e. curPhaseIdx = dFactor
             */
            if ( (++curPhaseIdx) >= dFactor ) {

                /* calculate appropriate location for filter output */
                  real_T *filtShortOutput = filtShortOutputBase + curOutBufIdx;
                  real_T *filtLongOutput  = filtLongOutputBase  + curOutBufIdx;

                /* save *sums (short filter output) to  filtShortOutput
                 * save *(sums+1) (long filter output) to filtLongOutput
                 */
                *filtShortOutput = *sums++;
                *filtLongOutput  = *sums;

                /* reset sums to zero after transfering its content */
                *sums-- = 0.0;
                *sums   = 0.0;

                /* reset curBufIdx and invert curBuf when finished with current frame */
                if ( (++curOutBufIdx) >= outFrameSize ) curOutBufIdx = 0;

                /* reset curPhaseIdx to zero
                   reset cffLong and cffShort to their respective base */
                curPhaseIdx = 0;
                cffLong     = filtLong;
                cffShort    = filtShort;
            }

        } /* inFrameSize */

        /* increment indices for next channel */
        filtShortOutputBase += outFrameSize;
        filtLongOutputBase  += outFrameSize;
        tap0                += filtLenLong;
        sums                += 2;

    } /* channel */

    /* save common per channel parameters for next function call */
    *phaseIdx     = curPhaseIdx;
    *tapIdx       = curTapIdx;
}

#endif /* !INTEGER_CODE */

/* [EOF] 2chabank_fr_df_dd_rt.c */
