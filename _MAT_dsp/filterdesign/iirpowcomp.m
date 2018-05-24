function [q,a] = iirpowcomp(b,a,varargin)
%IIRPOWCOMP   IIR power complementary filter.
%   [Bp,Ap] = IIRPOWCOMP(B,A) returns the coefficients of the power
%   complementary IIR filter G(z) = Bp(z)/Ap(z) in vectors Bp and Ap,
%   given the coefficients of the IIR filter H(z) = B(z)/A(z) in
%   vectors B and A.  B must be symmetric (hermitian) or antisymmetric
%   (antihermitian) and of the same length as A.
%
%   The two power complementary filters satisfy the relation
%                     2          2
%               |H(w)|  +  |G(w)|   =   1.
%
%   [Bp,Ap,C] = IIRPOWCOMP(B,A) where C is a complex scalar of magnitude
%   one, forces Bp to satisfy the generalized hermitian property
%
%                         conj(Bp(end:-1:1)) = C*Bp.
%
%   When C is omitted, it is chosen as follows:
%   
%     - If B is real, C is chosen as 1 or -1, whichever yields Bp real.
%     - If B is complex, C always defaults to 1.
%
%   Ap is always equal to A.
%
%   EXAMPLE:
%      [b,a] = cheby1(4,.5,.4);
%      [bp,ap]=iirpowcomp(b,a);
%      fvtool(b,a,bp,ap,'MagnitudeDisplay','Magnitude squared');
%
%   See also TF2CA, TF2CL, CA2TF, CL2TF.

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,3,nargin,'struct'));

% Make sure b and a are valid, return them as rows and also
% return the filter order
[b,a,N] = inputparse(b,a);

% Find the auxiliary polynomial R(z)
r = auxpoly(b,a);

% compute the numerator of the power complementary transfer function
[q] = powercompnum(b,r,N,varargin{:});


%------------------------------------------------------------------------
function [b,a,N] = inputparse(b,a)
%INPUTPARSE   Parse input arguments, and return filter order
%   INPUTPARSE  checks if b and a are valid numerator and
%   denominator vectors, converts them to rows if necessary
%   and returns the filter order N.

N = length(b)-1; % Get the order of the numerator

% Check that b and a are vectors of the same length
if ~any(size(b)==1) || ~any(size(a)==1),
   error(message('dsp:iirpowcomp:FilterErr1'));
   return;
end
if length(b)~=length(a),
   error(message('dsp:iirpowcomp:FilterErr2'));
   return;
end

% Make sure b and a are rows
b = b(:).';
a = a(:).';

% Check that b is hermitian or antihermitian.
% Symmetric and antisymmetric are special cases

if N < 1,
    error(message('dsp:iirpowcomp:FilterErr3'));
    return;
end
%------------------------------------------------------------------------
function r = auxpoly(b,a)
%AUXPOLY  Compute auxiliary polynomial necessary for the computation
%         of the power complementary filter's numerator.

% Find the reversed conjugated polynomial of b and a by replacing z with z^(-1) and
% conjugating the coefficients
revb = conj(b(end:-1:1));
reva = conj(a(end:-1:1));


% R(z) = z^(-N)*[conj(fliplr(b(z)))*b(z)-conj(fliplr(a(z)))*a(z)]
r = conv(revb,b) - conv(a,reva);

%------------------------------------------------------------------------
function [q] = powercompnum(b,r,N,varargin)
%POWERCOMPNUM  Compute numerator of power complementary filter.


if isreal(b) && (nargin == 3),
    % Try to get a real q with c = 1 and c = -1
    q = numrecursion(r,N,1); 
    
    if ~isreal(q),
        q = numrecursion(r,N,-1); 
    end
    
    if ~isreal(q),
        error(message('dsp:iirpowcomp:FilterErr4'));
        return
    end
else
    % If numerator is complex, we use c=1 when c is not given
    c = 1;
    if nargin == 4,
        c = varargin{1};
        if max(size(c)) > 1,
            error(message('dsp:iirpowcomp:FilterErr5'));
            return
        end
        if abs(c) - 1 > eps^(2/3),
            error(message('dsp:iirpowcomp:FilterErr6'));
            return
        end
    end
    
    [q] = numrecursion(r,N,c); 
end


%------------------------------------------------------------------------
function [q] = numrecursion(r,N,c)
%NUMRECURSION, compute the numerator of the power complementary function.
%   NUMRECURSION recursively computes the numerator q of the power
%   complementary transfer function needed to compute the allpass
%   decomposition.
%   Inputs:
%    r - auxiliary polynomial used in the recursion (defined above).
%    N - order of the IIR filter.
%
%   Output:
%    q - numerator of the power complemetary transfer function.

 
% Initialize recursion
q(1) = sqrt(-r(1)./c); q(N+1)=conj(c*q(1));
q(2) = -r(2)./(2*c*q(1)); q(N)=conj(c*q(2));

% The limit of the for loop depends on the order being odd or even
for n = 3:ceil(N/2),
   q(n) = (-r(n)./c - q(2:n-1)*q(n-1:-1:2).')./(2*q(1));
   q(N+2-n) = conj(c*q(n));
end

% Compute middle coefficient separately when order is even
if rem(N,2) == 0,
   q((N+2)/2) = (-r((N+2)/2)./c - q(2:(N+2)/2-1)*q((N+2)/2-1:-1:2).')./(2*q(1));
end

% [EOF] - IIRPOWCOMP.M
