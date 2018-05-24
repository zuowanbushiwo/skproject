/* MWDSP_Sort_Qk_Val_R Function to sort an input array of real
 * singles for Sort block in DSP System Toolbox
 *
 *  Implement Quicksort in-place sort-by-value algorithm
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#ifdef MW_DSP_RT
#include "src/dspsrt_rt.h"
#else
#include "dspsrt_rt.h"
#endif

static boolean_T findPivot(real32_T *dataArray, int_T i, int_T j, int_T *pivot )
{
    int_T   mid = (i+j)>>1;
    int_T   k;
    real32_T  a, b, c;

    if(dataArray[i] > dataArray[mid]) {
        real32_T   tmp = dataArray[i];
        dataArray[i] = dataArray[mid];
        dataArray[mid] = tmp;
    }
    if(dataArray[i] > dataArray[j]) {
        real32_T   tmp = dataArray[i];
        dataArray[i] = dataArray[j];
        dataArray[j] = tmp;
    }
    if(dataArray[mid] > dataArray[j]) {
        real32_T   tmp = dataArray[mid];
        dataArray[mid] = dataArray[j];
        dataArray[j] = tmp;
    }

    a = dataArray[i];
    b = dataArray[mid];
    c = dataArray[j];

    if (a < b) {
        *pivot = mid;
        return((boolean_T)1);
    }
    if (b < c) {
        *pivot = j;
        return((boolean_T)1);
    }
    for (k=i+1; k <= j; k++) {
        real32_T d = dataArray[k];
        if ( (d<a) || (d>a) ) {
          /* d!=a and none of them is NaN */
          *pivot = (d < a) ? i : k ;
          return((boolean_T)1);
        }
    }
    return((boolean_T)0);

}

static int_T partition(real32_T *dataArray, int_T i, int_T j, int_T pivot )
{
    real32_T pval = dataArray[pivot];
    int_T count = j-i;

    while ( (i <= j) && (count >= 0) ) {
        while(dataArray[i] < pval) {
            ++i;
        }
        while(dataArray[j] >= pval) {
            --j;
        }
        if (i<j) {
            real32_T   tmp = dataArray[i];
            dataArray[i] = dataArray[j];
            dataArray[j] = tmp;
            ++i;
            --j;
        }
        --count;
    }
    return(i);
}

/* The recursive quicksort routine: */
LIBMW_SRC_API void MWDSP_Sort_Qk_Val_R(real32_T *dataArray, int_T i, int_T j )
{
    int_T pivot;
    if (findPivot(dataArray, i, j, &pivot)) {
        int_T k = partition(dataArray, i, j, pivot);
        MWDSP_Sort_Qk_Val_R(dataArray, i, k-1);
        MWDSP_Sort_Qk_Val_R(dataArray, k, j);
    }
}

#endif /* !INTEGER_CODE */


/* [EOF] */
