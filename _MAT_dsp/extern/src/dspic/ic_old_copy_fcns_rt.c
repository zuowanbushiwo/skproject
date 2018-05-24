/*
 * IC run-time support functions for use by the following
 * three delay blocks:
 *   - Integer Delay             (sdspdly2)
 *   - Variable Integer Delay    (sdspvidly2)
 *   - Variable Fractional Delay (sdspvfdly2)
 *
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#ifdef MW_DSP_RT
#include "src/dsp_ic_rt.h"
#else
#include "dsp_ic_rt.h"
#endif

LIBMW_SRC_API void MWDSP_CopyScalarICs( byte_T       *dstBuff, 
                                 const byte_T *ICBuff, 
                                 int_T         numElems, 
                                 const int_T   bytesPerElem );



LIBMW_SRC_API void MWDSP_DelayCopyScalarICs(byte_T *buffer,
                              byte_T *ICPtr,
                              const int_T nChansXdWorkRows,
                              const int_T  bytesPerElement
                              )
{
    MWDSP_CopyScalarICs(buffer, ICPtr, nChansXdWorkRows, bytesPerElement);
}


LIBMW_SRC_API void MWDSP_DelayCopyVectorICs(byte_T *buffer,
                              byte_T *ICPtr,
                              int_T nChans,
                              const int_T dWorkRows,
                              const int_T bytesPerElement
                              )
{
    byte_T      *dstBuffer       = buffer;
    const int_T  bytesPerChannel = (dWorkRows - 1) * bytesPerElement;
    
    while (nChans-- > 0) {
        memcpy( dstBuffer, ICPtr, bytesPerChannel );
        dstBuffer += bytesPerChannel + bytesPerElement;
    }
}


LIBMW_SRC_API void MWDSP_DelayCopy3DSampMatrixICs(byte_T *buffer,
                                    byte_T *ICPtr,
                                    int_T nChans,
                                    const int_T dWorkRows,
                                    const int_T bytesPerElement,
                                    const int_T dataPortWidth
                                    )
{
    const int_T   bytesPerPage = bytesPerElement * dataPortWidth;

    while (nChans--) {
        int_T j;
	for (j=0; j < dWorkRows-1; j++ ) {
	    memcpy(buffer, ICPtr + j*bytesPerPage, bytesPerElement);
	    buffer += bytesPerElement; 
	}
        buffer += bytesPerElement;
	    ICPtr  += bytesPerElement;
    }
}


LIBMW_SRC_API void MWDSP_DelayCopy3DFrameMatrixICs(byte_T *buffer,
                                     byte_T *ICPtr,
                                     int_T nChans,
                                     const int_T dWorkRows,
                                     const int_T bytesPerElement
                                     )
{
    const int_T   bytesPerRow = bytesPerElement * nChans;

    while (nChans--) {
        int_T j;
	for (j=0; j < dWorkRows-1; j++ ) {
	    memcpy(buffer, ICPtr + j*bytesPerRow, bytesPerElement);
	    buffer += bytesPerElement; 
        }
        buffer += bytesPerElement; 
	    ICPtr  += bytesPerElement;
    }
}


/* [EOF] ic_old_copy_fcns_rt.c */

