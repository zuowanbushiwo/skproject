function [allpassnum, allpassden] = allpasslp2bs(wo, wt)
%ALLPASSLP2BS Allpass for lowpass to bandstop frequency transformation.
%   [AllpassNum,AllpassDen] = ALLPASSLP2BS(Wo,Wt) returns numerator,
%   ALLPASSNUM, and the denominator, ALLPASSDEN, of the allpass mapping filter.
%
%   Inputs:
%     Wo         - Frequency value to be transformed from the prototype filter.
%     Wt         - Desired frequency location in the transformed target filter.
%   Outputs:
%     AllpassNum - Numerator of the mapping filter
%     AllpassDen - Denominator of the mapping filter
%
%   Frequencies must be normalized to be between 0 and 1, with 1 corresponding
%   to half the sample rate.
%
%   Example:
%        % Allpass mapper changing the lowpass with cutoff frequency of Wo=0.5
%        % to the real bandstop with cutoff frequencies at Wt1=0.25 and Wt2=0.375
%        Wo = 0.5;
%        Wt = [0.25, 0.375];
%        [AllpassNum, AllpassDen] = allpasslp2bs(Wo, Wt);
%        % Calculate the spectrum of the allpass mapping filter
%        [h, f] = freqz(AllpassNum, AllpassDen, 'whole');
%        % Plot the phase response normalised to PI as a mapping function Wo(Wt)
%        plot(f/pi, abs(angle(h))/pi, Wt, Wo, 'ro');
%        title('The mapping function Wo(Wt)');
%        xlabel('New frequency, Wt');
%        ylabel('Old frequency, Wo');
%
%   See also IIRLP2BS and ZPKLP2BS.

%   References:
%     [1] Constantinides A.G., "Spectral transformations for digital filters",
%         IEE Proceedings, vol. 117, no. 8, pp. 1585-1590, August 1970.
%     [2] Nowrouzian, B. and A. G. Constantinides, "Prototype reference
%         transfer function parameters in the discrete-time frequency
%         transformations", Proc. 33rd Midwest Symposium on Circuits and
%         Systems, Calgary, Canada, vol. 2, pp. 1078-1082, 12-14 August 1990.
%     [3] Nowrouzian, B. and Bruton, L.T. "Closed-form solutions for
%         discrete-time elliptic transfer functions", Proceedings of
%         the 35th Midwest Symposium on Circuits and Systems, vol. 2,
%         Page(s): 784 -787, 1992.

%   Author(s): Dr. Artur Krukowski, University of Westminster, London, UK.

%   Copyright 1999-2013 The MathWorks, Inc.

%#codegen
%#ok<*EMCA>


% --------------------------------------------------------------------
% Perform the parameter validity check

validateattributes(wo,{'numeric'},{'scalar','real','>',0,'<',1},...
                  'allpasslp2bs','wo');
validateattributes(wt,{'numeric'},{'vector','numel',2,'real','>',0,'<',1},...
                  'allpasslp2bs','wt');
              
% ---------------------------------------------------------------------
% Calculate the mapping filter

wc         = sum(wt) / 2;
bw         = max(wt) - min(wt);
alpha      = cos(pi*(wo+bw)/2) / cos(pi*(wo-bw)/2);
beta       = cos(pi*wc) / cos(pi*bw/2);               % Exact bandedges fix
allpassden = [1     -beta*(1+alpha) alpha];
allpassnum = [alpha -beta*(1+alpha) 1];
