%% Generating Testbenches for Development of Signal Processing Algorithms
% This example shows how to quickly generate DSP Algorithm testbenches to
% accelerate the development and testing of streaming signal processing
% algorithms. This example uses the HelperGenDSPTestbenchUI function from
% which you can choose DSP sources and sinks. A Parameter Tuning UI can
% also be added to tune the parameters of the custom algorithm.

% Copyright 2013 The MathWorks, Inc.

%% Introduction
% Most algorithm frameworks in DSP System Toolbox will contain an
% initialization phase and a streaming phase. For example, if you want to
% create a testbench for reading an audio signal from a microphone for 30
% seconds and viewing its frequency spectrum, you can write something like:

% Initialize
SamplesPerFrame = 1024;
AR = dsp.AudioRecorder('SamplesPerFrame',SamplesPerFrame,...
     'OutputDataType','double','QueueDuration',2);
Fs = AR.SampleRate;
SA =dsp.SpectrumAnalyzer('SampleRate',Fs,'PlotAsTwoSidedSpectrum',false,...
    'FrequencyScale','Log','SpectralAverages',20);

% Stream
tic;
while toc < 30 % Stream for 30 seconds
    % Read frame from microphone
    audioIn = step(AR);
    % View audio spectrum
    step(SA,audioIn);
end

% Terminate
release(AR);

%% Generating Testbenches Automatically
% Use HelperDSPGenTestbenchUI to generate testbenches automatically. You
% can select the sources and sinks you want to use for the testbench as
% well as the name of a custom algorithm you want to call to process the
% streaming signals. Note that when you select more than one source, the
% signals generated by the sources are added together. Also note that
% default parameters are generated for all sources and sinks. These
% parameters should be customized to meet individual needs.

HelperGenDSPTestbenchUI

displayEndOfDemoMessage(mfilename)
