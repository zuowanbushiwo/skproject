function blkStruct = slblocks
%SLBLOCKS Defines the Simulink library block representation
%   for the DSP System Toolbox.

%   Copyright 1995-2010 The MathWorks, Inc.

blkStruct.Name    = sprintf('DSP\nSystem\nToolbox');
blkStruct.OpenFcn = 'dsplib';
blkStruct.MaskInitialization = '';

blkStruct.MaskDisplay = ['plot(' ...
        '[0.212 0.356 0.356 NaN 0.302 0.356 0.41 NaN 0.212 0.5 0.5 NaN ' ...
         '0.3245 0.212 0.212 NaN 0.284 0.428 NaN 0.284 0.428 NaN 0.284 ' ...
         '0.428 NaN 0.284 0.3965 NaN 0.284 0.365 ' ...
         'NaN 0.676 0.592 0.592 NaN 0.64 ' ...
         '0.592 NaN 0.796 0.712 0.712 NaN 0.76 0.712 NaN 0.832 0.928 ' ...
         'NaN 0.88 0.88 NaN 0.175 0.196 0.2169 0.2379 0.2589 0.2798 ' ...
         '0.3008 0.3218 0.3427 0.3637 0.3847 0.4056 0.4266 0.4476 ' ...
         '0.4685 0.4895 0.5105 0.5315 0.5524 0.5734 0.5944 0.6153 ' ...
         '0.6363 0.6573 0.6782 0.6992 0.7202 0.7411 0.7621 0.7831 ' ...
         '0.804 0.825],' ...
        '[0.938 0.938 0.776 NaN 0.857 0.776 0.857 NaN 0.776 0.776 ' ...
         '0.6032 NaN 0.308 0.308 0.776 NaN 0.704 0.704 NaN 0.632 0.632 ' ...
         'NaN 0.56 0.56 NaN 0.488 0.488 NaN 0.416 0.416  ' ...
         'NaN 0.36 0.36 0.22 NaN 0.29 0.29 ' ...
         'NaN 0.36 0.36 0.22 NaN 0.29 0.29 NaN 0.36 0.36 NaN 0.36 0.22 NaN ' ...
         '0.048 0.05365 0.07037 0.09747 0.1338 0.178 0.2281 0.2822 0.338 ' ...
         '0.3932 0.4455 0.4929 0.5334 0.5653 0.5873 0.5986 0.5986 0.5873 ' ...
         '0.5653 0.5334 0.4929 0.4455 0.3932 NaN NaN NaN 0.178 0.1338 ' ...
         '0.09747 0.07037 0.05365 0.048]);' ...
         'text(0.6,0.75,''DSP'');'];

% Define the library list for the Simulink Library browser.
% Return the name of the library model and the name for it
Browser(1).Library = 'dsplibv4';
Browser(1).Name    = 'DSP System Toolbox';
Browser(1).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;

% Define information for model updater
blkStruct.ModelUpdaterMethods.fhSeparatedChecks = @spblksUpdateModel;
blkStruct.ModelUpdaterMethods.fhDetermineBrokenLinks = @spblksBrokenLinksMapping;

% End of slblocks.m

% LocalWords:  dsplibv
