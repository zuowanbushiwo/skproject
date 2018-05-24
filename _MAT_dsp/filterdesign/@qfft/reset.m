function reset(F)
%RESET  Resets quantizers in the object.
%   RESET(F) resets all the quantizers in QFFT object F.
%
%   Example:
%     w = warning('on');
%     F = qfft;
%     y = fft(F,randn(16,1));
%     reset(F)
%     qreport(F)
%     warning(w);
%
%   See also QFFT, QFFT/FFT, QREPORT.

%   Thomas A. Bryan, 31 August 1999
%   Copyright 1999-2003 The MathWorks, Inc.

reset(F.coefficientformat,F.inputformat,F.outputformat,F.multiplicandformat, ...
    F.productformat,F.sumformat);
