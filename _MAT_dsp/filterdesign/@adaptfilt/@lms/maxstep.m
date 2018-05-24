function [mumax,mumaxmse] = maxstep(h,x)
%MAXSTEP  Maximum step size for adaptive filter convergence.
%
%   MUMAX = MAXSTEP(H,X) predicts a bound on the step size to  provide
%   convergence of the mean values of the adaptive filter coefficients.  
%
%   The columns of the matrix X contain individual input signal sequences.
%   The signal set is assumed to have zero mean or nearly so.  
% 
%   [MUMAX,MUMAXMSE] = MAXSTEP(H,X) predicts a bound on the adaptive
%   filter step size to provide convergence of the adaptive filter
%   coefficients in mean square.  
%
%   See also MSEPRED, MSESIM, FILTER.

%   Author(s): S.C. Douglas
%   Copyright 1999-2009 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

xt = x(:);                          %  Stack input sequences into one vector

%  Compute Step size bound for convergence in the mean
L = length(h.Coefficients);              %  Length of coefficient vector
mumax = 2/(mean(xt.*xt)*L);         %  Calculate sufficient Step size bound

if (nargout > 1)
    [~,~,~,~,~,dLam,kurt] = firwiener(L-1,x,x); % Third input is 'dummy'
    mumaxmse = 2/(max(dLam)*(kurt+2)+sum(dLam));  %  Compute MSE Step size bound
    if (h.StepSize > mumaxmse/2) || (h.StepSize <= 0)       %  Test h.StepSize and warn if outside reasonable limits
        warning(message('dsp:adaptfilt:lms:maxstep:InvalidStepSize'));
    end
end
