function Hm = firinterp(L,num)
%FIRINTERP Direct-Form FIR Polyphase Interpolator.
%   Hm = MFILT.FIRINTERP(L,NUM) returns a direct-form FIR polyphase
%   interpolator Hm.
% 
%   L is the interpolation factor. It must be an integer. If not specified,
%   it defaults to 2.
%
%   NUM is a vector containing the coefficients of the FIR lowpass filter
%   used for interpolation. If omitted, a low-pass Nyquist filter of gain L
%   and cutoff frequency of Pi/L is designed by default. 
%
%   EXAMPLE: 
%      %Interpolation by a factor of 2 (used to convert from 22.05kHz
%      %to 44.1kHz)
%      L = 2;                               % Interpolation factor
%      Hm = mfilt.firinterp(L);             % We use the default filter
%      Fs = 22.05e3;                        % Original sampling frequency: 22.05kHz
%      n = 0:5119;                          % 5120 samples, 0.232 second long signal
%      x  = sin(2*pi*1e3/Fs*n);             % Original signal, sinusoid at 1kHz
%      y = filter(Hm,x);                    % 10240 samples, still 0.232 seconds
%      stem(n(1:22)/Fs,x(1:22),'filled')    % Plot original sampled at 22.05kHz 
%      hold on                              % Plot interpolated signal (44.1kHz) in red
%      stem(n(1:44)/(Fs*L),y(25:68),'r')
%      xlabel('Time (sec)');
%      ylabel('Signal value')
%
%   See also MFILT/STRUCTURES.

%   Author: V. Pellissier 
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(0,2,nargin,'struct'));

Hm = mfilt.firinterp;

Hm.FilterStructure = 'Direct-Form FIR Polyphase Interpolator';

if nargin>0
  Hm.InterpolationFactor = L;
end

if nargin < 2,
	Hm.Numerator = defaultfilter(Hm,Hm.InterpolationFactor,1);
elseif isa(num,'dfilt.singleton') && isfir(num),    
    [b,a] = tf(num);
    Hm.Numerator = b;
else
    num = num(:).';
	Hm.Numerator = num;
end

% [EOF]
