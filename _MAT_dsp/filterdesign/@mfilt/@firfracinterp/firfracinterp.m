function Hm = firfracinterp(L,M,num) %#ok<*STOUT,INUSD>
%FIRFRACINTERP Direct-Form FIR Polyphase Fractional Interpolator.
%   Hm = MFILT.FIRFRACINTERP(L,M,NUM) constructs a direct-form FIR
%   polyphase fractional interpolator.
%   
%   L is the interpolation factor. It must be an integer. If not specified,
%   it defaults to 3.
%
%   M is the decimation factor. It must be an integer. If not specified, it
%   defaults to 1. If L is also not specified, M defaults to 2.
%
%   NUM is a vector containing the coefficients of the FIR lowpass filter
%   used for interpolation. If omitted, a low-pass Nyquist filter of gain L
%   and cutoff frequency of Pi/max(L,M) is used by default.
%
%   NOTE: MFILT.FIRFRACINTERP is obsolete and will be removed in the future.
%   Use MFILT.FIRSRC instead.
%
%   EXAMPLE: 
%      %Sample-rate conversion by a factor of 3/2 (used to convert from 32kHz to 48kHz)
%      L  = 3; M = 2;                       % Interpolation/decimation factors.
%      Hm = mfilt.firfracinterp(L,M);       % We use the default filter
%      Fs = 32e3;                           % Original sampling frequency: 32kHz
%      n = 0:6799;                          % 6800 samples, 0.212 second long signal
%      x  = sin(2*pi*1e3/Fs*n);             % Original signal, sinusoid at 1kHz
%      y = filter(Hm,x);                    % 10200 samples, still 0.212 seconds
%      stem(n(1:32)/Fs,x(1:32),'filled')    % Plot original sampled at 32kHz
%      hold on
%      % Plot fractionally interpolated signal (48kHz) in red
%      stem(n(1:48)/(Fs*L/M),y(20:67),'r')
%      xlabel('Time (sec)');ylabel('Signal value')
%
%   See also MFILT/STRUCTURES.

%   Copyright 1999-2012 The MathWorks, Inc.

error(message('dsp:mfilt:firfracinterp:firfracinterp:Obsolete'));

error(nargchk(0,3,nargin,'struct')); %#ok<UNRCH,*NCHKN>
 
if nargin==0
    % Default values
    L=3;M=2;
elseif nargin==1
	M=1;
 end
if length(L)>1, error(message('dsp:mfilt:firfracinterp:firfracinterp:MFILTErr'));end

Hm = mfilt.firfracinterp;
Hm.FilterStructure = 'Direct-Form FIR Polyphase Fractional Interpolator';
Hm.RatechangeFactors = [L M];

if nargin < 3,
	Hm.Numerator = defaultfilter(Hm,L,M);
elseif isa(num,'dfilt.singleton') && isfir(num),    
    [b,a] = tf(num);
    Hm.Numerator = b;
else
    num = num(:).';
	Hm.Numerator = num;
end
