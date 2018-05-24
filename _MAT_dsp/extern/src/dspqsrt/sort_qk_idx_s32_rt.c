/* MWDSP_Sort_Qk_Idx_S32 Function to sort an input array of real 
 * int32_T for Sort block in DSP System Toolbox
 *
 * Implement Quicksort algorithm using indices
 * Note: this algorithm is different from MATLAB's sorting
 * for complex values with same magnitude.
 *
 * Sorts an array of doubles based on the "Quicksort" algorithm,
 * using an index vector rather than the data itself.
 *
 *  Copyright 2013 The MathWorks, Inc.
 */

#ifdef MW_DSP_RT
#include "src/dspsrt_rt.h"
#else
#include "dspsrt_rt.h"
#endif

static boolean_T findPivot(const int32_T *dataArray, uint32_T *idxArray,
                               int_T i, int_T j, int_T *pivot )
{
    int_T  mid = (i+j)/2;
    int_T  k;
    int32_T a, b, c;

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
        int32_T d = *(dataArray + *(idxArray + k));
        if (d != a) {
          *pivot = (d < a) ? i : k ;
          return((boolean_T)1);
        }
    }
    return((boolean_T)0);
}

static int_T partition(const int32_T *dataArray, uint32_T *idxArray,
                           int_T i, int_T j, int_T pivot )
{
    int32_T pval = *(dataArray + *(idxArray + pivot));

    while (i <= j) {
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
    }
    return(i);
}

/* The recursive quicksort routine: */
LIBMW_SRC_API void MWDSP_Sort_Qk_Idx_S32(const int32_T *dataArray, uint32_T *idxArray, int_T i, int_T j )
{
    int_T pivot;
    if (findPivot(dataArray, idxArray, i, j, &pivot)) {
        int_T k = partition(dataArray, idxArray, i, j, pivot);
        MWDSP_Sort_Qk_Idx_S32(dataArray, idxArray, i, k-1);
        MWDSP_Sort_Qk_Idx_S32(dataArray, idxArray, k, j);
    }
}


/* [EOF] */
