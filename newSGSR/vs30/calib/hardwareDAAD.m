function [DBNplay, DBNrec] = hardwareDAAD(keyword, playSig, DAchan, fltIndex);
% set hardware for DA/AD calibration
% keyword = newsig | dealloc

%MeasureDAADtrf(playSig, DAchan, fltIndex, startAtt, minAtt, BGstd, MaxStd);
%function [recSig, measStd, allAtt, Anom] = 
%function [recSig, ANOM] = CalibPlayRecSys2(playSig, DACchannel, fltIndex, Atten, DoPlot);

if nargin<5, DoPlot=0; end;

global SGSR PD1

% 16-bit dama buffers for play & record
% quite a number of samples seem to get lost in a combined 
% play/record action, even when the DAC output of the PD1 is 
% directly connected to the ADC. For the present routing,
% the delay for this setup is 9 samples, independent of
% sample frequency. The first sample of the play seems to 
% be played, so we only need trailing zeros, not heading zeros.

persistent DBNplay DBNrecord Nplay

switch keyword,
case 'newsig', % this signal is played for the first time; prepare hardware
   ADCchannel = SGSR.ADCchannel;
   DACchannel = ChannelNum(DACchannel);
   N_LAG = 9;
   Nplay = length(playSig) + N_LAG;
   DBNplay = ML2dama([playSig(:)' zeros(1, N_LAG)]);
   DBNrecord = ML2dama(zeros(1, Nplay));
end % switch/case

% this signal is played for the first time; prepare hardware

global SGSR;
SamP = 1e6/SGSR.samFreqs(fltIndex);

% AP2 play & record instructions
s232('record',DBNrecord);
s232('play',DBNplay);

if ~isempty(playSig), % this signal is played for the first time; prepare hardware
   % prepare hardware for D/A conversion
   % routing is not standard because of combined play/record action
   nStreams = [1 1]; % 1-IB, 1 OB
   specOB = [1, PD1.OB(1), PD1.ADC(ADCchannel)]; % OB[0] <- ADC[x]
   switch DACchannel
   case {1,2}, % single-channel D/A
      specIB = [1, PD1.IB(1), PD1.DAC(DACchannel)]; % IB[0] -> DAC[0]
      addSimp = [];
   otherwise, % dual channel D/A
      addSimp = [1, PD1.ireg(1), PD1.DAC(1) ; ... % ireg[0] -> DAC[0]
            1, PD1.ireg(1), PD1.DAC(2)]; % ireg[0] -> DAC[1]
      specIB =  [1, PD1.IB(1), PD1.ireg(1)]; % IB[0] -> ireg[0]
   end
   % SS1 switching  is trivial - not dependent on A/D
   [preGo, postGo] = SS1switching(DACchannel, fltIndex); % preGo is final connection
   preGo = [preGo; postGo]; % at once in final setting
   HWsettings = CollectInStruct(Nplay, SamP, nStreams, addSimp, specIB, specOB, preGo);
   prepareHardware4DA(HWsettings);
end

% attenuators
setPA4s(Atten);
pause(0.1);
% trigger PD1
s232('PD1arm',1);
s232('PD1go',1);

% wait until conversion has finished and get recorded samples
while (s232('PD1status',1)~=0), end;
pause(0.1);
s232('PD1clrIO',1);
recSig = dama2ML(DBNrecord); % dama -> Matlab
% deallocate dama buffers

%s232('deallot', DBNplay); 
%s232('deallot', DBNrecord); 

% throw away first N_LAG garbage samples (see comment above)
recSig(1:N_LAG) = [];
% HARDWARE PROBLEMS -- quick & dirty fix
ANOM = 0;
[recSig, ANOM] = localFIXspikes(recSig);

if DoPlot,
   figure;
   plot(recSig);
   waitfor(gcf);
end

%----------------locals---------
function [X, ANOM] = localFIXspikes(X);
ANOM = 0;
jumps = find(abs(X)>6*std(X));
if isempty(jumps), return; end;
ANOM = 1;
for isam=jumps,
   if isam==1, X(isam)=0;
   else, X(isam)= X(isam-1);
   end
end
% DD(jumps) = 0;
% X = cumsum(DD);



