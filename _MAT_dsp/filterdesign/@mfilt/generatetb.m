%GENERATETB Generate an HDL Test Bench.
%   GENERATETB(Hb, TBTYPE) automatically generates VHDL code or
%   Verilog code that functionally verifies the filter generated by
%   GENERATEHDL(Hb) using any or all of impulse, step, ramp, chirp, or
%   noise waveforms as input stimulus  for the filter.  TBTYPE is one of
%   'VHDL' or 'Verilog' or a cell array containing any or all of these.
%   The default file name is 'filter_tb', with a default extension of
%   '.vhd' or '.v' depending on which testbench types are selected. The
%   file is written to the target directory, under the current MATLAB 
%   directory, which defaults to 'hdlsrc'.  This directory is created
%   if it does not exist.
%
%   GENERATETB(Hb, TBTYPE, PARAMETER1, VALUE1, PARAMETER2, VALUE2, ...) 
%   generates the test bench with parameter/value pairs. Valid 
%   properties and values for GENERATETB are listed in the Filter 
%   Design HDL Coder documentation section "Property Reference."
%
%   GENERATETB(Hb, PARAMETER1, VALUE1, PARAMETER2, VALUE2, ...) 
%   generates the test bench with the TBTYPE as determined by the previous
%   GENERATEHDL(Hb) step. The TBTYPE defaults to that as specified during
%   the GENERATEHDL(Hb) step.
%
%   EXAMPLES:
%   % Setup filter
%   Hm = mfilt.cicdecim(4);
%   generatehdl(Hm);
%
%   % Testbench Examples
%   generatetb(Hm, 'VHDL');
%   generatetb(Hm,'VHDL','TestBenchName','MyTestBench');
%   generatetb(Hm,{'Verilog','VHDL'}, 'TestBenchStimulus',{'impulse','chirp'});
%   generatetb(Hm,'VHDL','TestBenchUserStimulus', sin(2*pi*[0:0.01:1]));
%
%   % Testbench Example without explicit TBTYPE specification
%   generatehdl(Hb); % Default target language is VHDL
%   generatetb(Hb);  % TBTYPE is set to VHDL as per previous step.
%   generatehdl(Hb, 'TargetLanguage', 'Verilog');
%   generatetb(Hb);  % TBTYPE is set to Verilog as per previous step.
%
%   See also GENERATEHDL, GENERATETBSTIMULUS, FDHDLTOOL

%   Copyright 2005-2009 The MathWorks, Inc.

% MATLAB file help for generatetb method.

% [EOF]
