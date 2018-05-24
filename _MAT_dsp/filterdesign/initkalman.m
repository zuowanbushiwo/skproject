function S = initkalman(w0,K0,Qm,Qp,Zi)
%INITKALMAN Initialize structure for Kalman adaptive filter.
%   S = INITKALMAN(W0,K0,Qm,QP) returns the fully populated structure that 
%   must be used when calling ADAPTKALMAN. W0 is the initial value of the filter 
%   coefficients. Its length should be equal to the filter order plus one.
%
%   K0 is the initial state error covariance matrix. It should be a hermitian 
%   symmetric square matrix with each dimension equal to length(W0).
%
%   Qm is the measurement noise variance and Qp is the process noise covariance
%   matrix.
%
%   S = INITKALMAN(W0,K0,Qm,QP,Zi) specifies the filter initial conditions. If
%   omitted or specified as empty, the default value is used, i.e., a zero vector
%   of length one less than length(W0).
%
%   See also ADAPTKALMAN

%   References: 
%     [1] S. Haykin, "Adaptive Filter Theory", 3rd Edition,
%         Prentice Hall, N.J., 1996.
%     [2] A. H. Sayed and T. Kailath, "A state-space approach to RLS
%         adaptive filtering". IEEE Signal Processing Magazine, 
%         July 1994. pp. 18-60.  
%
%   Author(s): A. Ramasubramanian
%   Copyright 1999-2013 The MathWorks, Inc.

error(nargchk(4,5,nargin,'struct'));

% Convert w0 to a row vector if not already so.
w0 = w0(:).';

% Check FIR filter initial conditions.
if nargin < 5 | isempty(Zi),
    Zi = zeros(length(w0)-1,1);
end
if ~isequal(length(Zi),length(w0)-1),
    error(message('dsp:initkalman:InvalidDimensions1'));
end

% Check initial value of state error covariance matrix.
[mK0,nK0] = size(K0);
if ~isequal(mK0,nK0,length(w0)),
    error(message('dsp:initkalman:InvalidDimensions2'));
end
% Check if specified error covariance matrix is hermitian symmeteric.
if ~isequal(K0,K0')
    warning(message('dsp:initkalman:ImproperParam'));
end

% Check if measurement noise variance is scalar.
if ~(isnumeric(Qm) && length(Qm)==1)
    error(message('dsp:initkalman:FilterErr'));
end

% Check if process noise covariance matrix is of right order.
[Mp,Np] = size(Qp);
if ~isequal(Mp,Np,length(w0))
    error(message('dsp:initkalman:InvalidDimensions3'));
end

% Assign structure fields only after error checking is complete:
S.coeffs  = w0;
S.states  = Zi;
S.errcov  = K0;
S.measvar = Qm;
S.procov  = Qp;
S.gain    = [];  % Will be assigned after first call to adaptkalman.
S.iter    = 0;   % Iteration count.

% [EOF] 
