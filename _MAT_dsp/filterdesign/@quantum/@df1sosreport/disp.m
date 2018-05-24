function disp(this)
%DISP   Display this object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

dispheader(this);
dispinfo(this.Input,'Input: ');
dispinfo(this.Output,'Output: ');
dispinfo(this.NumStates,'Num States: ');
dispinfo(this.DenStates,'Den States: ');
dispinfo(this.NumProd,'Num Prod: ');
dispinfo(this.DenProd,'Den Prod: ');
dispinfo(this.NumAcc,'Num Acc: ');
dispinfo(this.DenAcc,'Den Acc: ');

% [EOF]
