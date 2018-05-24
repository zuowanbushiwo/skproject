/* MWDSP_Sort_Qk_Idx_D Function to sort an input array of real
 * doubles for Sort block in DSP System Toolbox
 *
 * Implement Quicksort algorithm using indices
 * Note: this algorithm is different from MATLAB's sorting
 * for complex values with same magnitude.
 *
 * Sorts an array of doubles based on the "Quicksort" algorithm,
 * using an index vector rather than the data itself.
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#ifdef MW_DSP_RT
#include "src/dspsrt_rt.h"
#else
#include "dspsrt_rt.h"
#endif

static boolean_T findPivot(const real_T *dataArray, uint32_T *idxArray,
                               int_T i, int_T j, int_T *pivot )
{
    int_T  mid = (i+j)/2;
    int_T  k;
    real_T a, b, c;

    qsortIdxOrder3(i,mid,j);    /* order the 3 values */
    a = *(dataArray + *(idxArray + i  ));
    b = *(dataArray + *(idxArray + mid));
    c = *(dataArray + *(idxArray + j  ));

    if (a < b) {   /* pivot will be higher of 2 values */
        *pivot = mid;
        return((boolean_T)1);
    }
    if (b < c) {
        *pivot = j;
        return((boolean_T)1);
    }
    for (k=i+1; k <= j; k++) {
        real_T d = *(dataArray + *(idxArray + k));
        if ( (d<a) || (d>a) ) {
          /* d!=a and none of them is NaN */
          *pivot = (d < a) ? i : k ;
          return((boolean_T)1);
        }
    }
    return((boolean_T)0);
}

static int_T partition(const real_T *dataArray, uint32_T *idxArray,
                           int_T i, int_T j, int_T pivot )
{
    real_T pval = *(dataArray + *(idxArray + pivot));
    int_T count = j-i;

    while ( (i <= j) && (count>=0) ) {
        while( *( dataArray + *(idxArray+i) ) <  pval) {
            ++i;
        }
        while( *( dataArray + *(idxArray+j) ) >= pval) {
            --j;
        }
        if (i<j) {
            qsortIdxSwap(i,j)
            ++i; --j;
        }
        --count;
    }
    return(i);
}

/* The recursive quicksort routine: */
LIBMW_SRC_API void MWDSP_Sort_Qk_Idx_D(const real_T *dataArray, uint32_T *idxArray, int_T i, int_T j )
{
    int_T pivot;
    if (findPivot(dataArray, idxArray, i, j, &pivot)) {
        int_T k = partition(dataArray, idxArray, i, j, pivot);
        MWDSP_Sort_Qk_Idx_D(dataArray, idxArray, i, k-1);
        MWDSP_Sort_Qk_Idx_D(dataArray, idxArray, k, j);
    }
}

#endif /* !INTEGER_CODE */


/* [EOF] */
