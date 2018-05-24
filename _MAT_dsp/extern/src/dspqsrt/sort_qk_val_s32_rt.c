/* MWDSP_Sort_Qk_Val_S32 Function to sort an input array of real 
 * int32_T for Sort block in DSP System Toolbox
 *
 *  Implement Quicksort in-place sort-by-value algorithm
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#ifdef MW_DSP_RT
#include "src/dspsrt_rt.h"
#else
#include "dspsrt_rt.h"
#endif

static boolean_T findPivot(int32_T *dataArray, int_T i, int_T j, int_T *pivot )
{
    int_T   mid = (i+j)>>1;
    int_T   k;
    int32_T  a, b, c;

    if(dataArray[i] > dataArray[mid]) {
        int32_T   tmp = dataArray[i];
        dataArray[i] = dataArray[mid];
        dataArray[mid] = tmp;
    }
    if(dataArray[i] > dataArray[j]) {
        int32_T   tmp = dataArray[i];
        dataArray[i] = dataArray[j];
        dataArray[j] = tmp;
    }
    if(dataArray[mid] > dataArray[j]) {
        int32_T   tmp = dataArray[mid];
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
        int32_T d = dataArray[k];
        if (d != a) {
          *pivot = (d < a) ? i : k ;
          return((boolean_T)1);
        }
    }
    return((boolean_T)0);

}

static int_T partition(int32_T *dataArray, int_T i, int_T j, int_T pivot )
{
    int32_T pval = dataArray[pivot];

    while (i <= j) {
        while(dataArray[i] < pval) {
            ++i;
        }
        while(dataArray[j] >= pval) {
            --j;
        }
        if (i<j) {
            int32_T   tmp = dataArray[i];
            dataArray[i] = dataArray[j];
            dataArray[j] = tmp;
            ++i; 
            --j;
        }
    }
    return(i);
}

/* The recursive quicksort routine: */
LIBMW_SRC_API void MWDSP_Sort_Qk_Val_S32(int32_T *dataArray, int_T i, int_T j )
{
    int_T pivot;
    if (findPivot(dataArray, i, j, &pivot)) {
        int_T k = partition(dataArray, i, j, pivot);
        MWDSP_Sort_Qk_Val_S32(dataArray, i, k-1);
        MWDSP_Sort_Qk_Val_S32(dataArray, k, j);
    }
}


/* [EOF] */
