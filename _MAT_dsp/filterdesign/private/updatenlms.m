function S = updatenlms(x,e,S)
% Execute one iteration of the normalized LMS adaptive filter.

%   Author(s): A. Ramasubramanian
%   Copyright 1999-2002 The MathWorks, Inc.


uvec  = [x ; S.states(:)].';
unorm = uvec*uvec';
if unorm~=0
  uvec = uvec./(S.offset+unorm);
end

S.coeffs = S.leakage*S.coeffs + S.step*conj(uvec)*e;

% EOF

