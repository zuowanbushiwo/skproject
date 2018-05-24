function thisautoscale(this,s,binptaligned)
%THISAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

inputautoscalefl(this,s,binptaligned)
outputautoscalefl(this,s,binptaligned)

this.StateFracLength = getautoscalefl(this,s.States,true,this.StateWordLength);

super_thisautoscale(this,s,binptaligned);

% [EOF]
