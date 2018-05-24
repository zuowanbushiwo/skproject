function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute sliding-window RLS adaptive filter.
%   Y = FILTER(H,X,D) applies an SWRLS adaptive filter H to the input
%   signal in  the vector X and the desired signal in the vector D. The
%   estimate of the desired response signal is returned in Y.  X and D must
%   be of the same length.
%
%   [Y,E] = FILTER(H,X,D) also returns the prediction error E.
%
%   EXAMPLE: 
%      %System Identification of a 32-coefficient FIR filter 
%      %(500 iterations).
%      x  = randn(1,500);     % Input to the filter
%      b  = fir1(31,0.5);     % FIR system to be identified
%      n  = 0.1*randn(1,500); % Observation noise signal
%      d  = filter(b,1,x)+n;  % Desired signal
%      P0 = 10*eye(32);       % Initial correlation matrix inverse
%      lam = 0.99;            % RLS forgetting factor
%      N  = 64;               % block length
%      h = adaptfilt.swrls(32,lam,P0,N);
%      [y,e] = filter(h,x,d);
%      subplot(2,1,1); plot(1:500,[d;y;e]);
%      title('System Identification of an FIR filter');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,1,2); stem([b.',h.Coefficients.']);
%      legend('Actual','Estimated'); 
%      xlabel('coefficient #'); ylabel('coefficient value'); grid on;
%
%   See also MSESIM, RESET.

%   References: 
%     [1] M. Hayes, Statistical Digital Signal Processing and Modeling
%         (New York:  Wiley, 1996). 
%     [2] S. Haykin, Adaptive Filter Theory, 4th Ed.  (Upper Saddle 
%         River, NJ:  Prentice Hall, 2002).

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Variable initialization
ntr = length(x);            %  temporary number of NumSamplesProcessed
L = h.FilterLength;               %  number of coefficients
N = h.SwBlockLength;             %  block length 
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
X = zeros(L+N-1,1);         %  initialize temporary input signal buffer
D = zeros(N,1);             %  initialize temporary desired signal buffer
nnL = 1:L;                  %  index variable used for input signal buffer
nnLpNm1 = nnL + N - 1;      %  index variable used for input signal buffer
nnN = 1:N-1;                %  index variable used for desired signal buffer
nnNp1 = nnN + 1;            %  index variable used for desired signal buffer
W = h.Coefficients;               %  initialize and assign coefficient vector
X(1:L+N-2)= h.States;       %  assign input signal buffer
D(nnN)= h.DesiredSignalStates; %  assign desired signal buffer
lam = h.ForgettingFactor;   %  assign forgetting factor
P = h.invcov;               %  initialize and assign covariance matrix
olam = 1/lam;               %  assign inverse forgetting factor
olamNm1 = lam^(1-N);        %  assign (N-1)th power of inverse forgetting factor

%  Main Loop

for n=1:ntr,
    
    %  Update input and desired signal buffers
    
    X(2:L+N-1) = X(1:L+N-2);  %  shift temporary input signal buffer down
    X(1) = x(n);              %  assign current input signal sample
    D(nnNp1) = D(nnN);        %  shift temporary desired signal buffer down
    D(1) = d(n);              %  assign current desired signal sample
    
    %  Covariance matrix update 
    
    XL = X(nnL);  
    XP = XL'*P;
    PX = P*XL;
    invden = 1/(lam + XP*XL);
    K = invden*PX;          %  compute Kalman gain vector
    P = olam*(P - K*XP);    %  update covariance matrix
    
    %  Compute output signal, error signal, and first part of coefficient updates
    
    y(n) = W*XL;            %  compute and assign current output signal sample
    e(n) = d(n) - y(n);     %  compute and assign current error signal sample
    W = W + e(n)*K';        %  update filter coefficient vector
    
    %  Covariance matrix "down-date"
    
    XL = X(nnLpNm1);  
    XP = XL'*P;
    PX = P*XL;
    invden = 1/(-olamNm1 + XP*XL);
    KN = invden*PX;         %  compute Kalman gain vector
    P = P - KN*XP;          %  "down-date" covariance matrix
    
    %  Compute last part of coefficient updates
    
    E = D(N) - W*XL;        %  compute trailing error signal sample
    W = W + E*KN';          %  "down-date" filter coefficient vector
    
end

%  Save States
h.invcov = P;                 %  save final inverse covariance matrix
h.KalmanGain = K;             %  save final Kalman gain vector
h.DesiredSignalStates = D(nnN); %  save final desired signal States
savestates(h,W,X,ntr,L+N-1);  %  save common stuff

%  END OF PROGRAM
