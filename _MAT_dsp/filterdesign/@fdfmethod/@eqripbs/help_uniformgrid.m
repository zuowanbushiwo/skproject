function help_uniformgrid(~)
%HELP_UNIFORMGRID

%   Copyright 2008-2011 The MathWorks, Inc.

uniformgrid_str = sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
    '    HD = DESIGN(..., ''UniformGrid'', UGRID) specifies the type of frequency',...
    '    grid that is used to measure  the error between the actual and the desired',...
    '    frequency response of the filter. When UGRID is TRUE, approximation errors',...
    '    are measured over a uniform frequency grid. When UGRID is FALSE, a non-uniform ',...
    '    frequency grid is used. In some cases, emphasizing the number of frequency',...
    '    points in the proximity of transition regions of the filter response may',...
    '    improve the design. If omitted, UGRID defaults to TRUE except when ''MinPhase'',',...
    '    or ''MaxPhase'' options are set to non-default values.');
    
disp(uniformgrid_str);
disp(' ');


% [EOF]