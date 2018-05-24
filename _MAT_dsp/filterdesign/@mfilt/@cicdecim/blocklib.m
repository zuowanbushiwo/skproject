function [lib, srcblk,hasInputProcessing,hasRateOptions] = blocklib(~,~)
%BLOCKLIB Returns the library and source block 

% Copyright 2006-2012 The MathWorks, Inc.

lib = 'dspmlti4';
srcblk = 'CIC Decimation';

hasInputProcessing = false;
hasRateOptions = true;
