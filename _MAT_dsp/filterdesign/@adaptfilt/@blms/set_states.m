function s = set_states(h,s)
%SET_STATES Set the States.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


L = get(h,'FilterLength');

if length(s) ~= L,
    error(message('dsp:adaptfilt:blms:set_states:InvalidDimensions'));
end

% Always store as a column
s = s(:);

h.privStates = s;
s = [];

warnifreset(h,'States');

