function dspblkblmsalgo(algo)
% DSPBLKFBLMS Mask dynamic dialog function for blms adaptive filter
% algorithm subsystem
% Copyright 1995-2007 The MathWorks, Inc.

if (strcmp(algo,'blms'))
    pos = [230   118   260   132];
else
    pos = [315   118   345   132];
end

wts = get_param(gcb, 'weights_algo');
if (strcmp(wts, 'off'))
    if (exist_block(gcb, 'Wts'))
        delete_line(gcb, 'Update/1', 'Wts/1');
        delete_block([gcb '/Wts']);
    end
else
    if ~(exist_block(gcb, 'Wts'))
        add_block('built-in/Outport', [gcb '/Wts'], 'Position', pos);
        add_line(gcb, 'Update/1', 'Wts/1');
    end    
end

% [EOF] dspblkblmsalgo.m