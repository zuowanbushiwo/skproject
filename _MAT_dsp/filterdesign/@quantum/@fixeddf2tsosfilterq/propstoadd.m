function p = propstoadd(this)
%PROPSTOADD   Return the properties to add to the parent object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

p = fieldnames(this);

p = {p{:}, ...
    'StageInputWordLength', ...
    'StageInputFracLength', ...
    'StageOutputWordLength', ...
    'StageOutputFracLength'};

% [EOF]
