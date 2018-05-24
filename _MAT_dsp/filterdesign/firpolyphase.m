function p = firpolyphase(num, L, M)
%FIRPOLYPHASE Polyphase decomposition for FIR filters.
%   P=FIRPOLYPHASE(NUM, L) decomposes the coefficient vector NUM into L
%   vectors and returns them in the polyphase matrix P. The ith row of
%   P represents the ith subfilter.
%
%   P=FIRPOLYPHASE(NUM, L, M) decomposes the coefficient vector NUM into L
%   vectors and then decompose each of these vectors into M vectors. It
%   thus provides two levels of decomposition and returns a polyphase
%   matrix P with L*M rows. The first M rows of P are the subfilters
%   derived from the first polyphase filter (issued form the first level of
%   decomposition).
%
% Example:
%   num=1:18;
%   L=2; M=3;
%   p1 = firpolyphase(num, L, M)

%   Author: V. Pellissier
%   Copyright 1988-2008 The MathWorks, Inc.

error(nargchk(2,3,nargin,'struct'));

N = length(num);
if nargin>2,
    Li=L; Mi=M;
    L = L*M;
end
M = ceil(N/L);

num = [num(:); zeros(L*M-N,1)];
p = reshape(num,L,M);

if nargin>2,
    % Re-order to get something equivalent to:
    %  pL = firpolyphase(num, L);
    %  p2 = [];
    %  for i=1:L,
    %       p2 = [p2; firpolyphase(pL(i,:), M)];
    %  end
    ridx = reshape(1:L,Li,Mi)';
    p = p(ridx(:),:);
end

% [EOF]
