% %PA5
% PA5=actxcontrol('PA5.x',[5 5 26 26]);
% %[PA5Config.DevNo,PA5Config.InitAtten,PA5Config.AdjustGainFlag]=deal(ChanNo,InitialAtten,AdjustAttenFlag); %Set device # and initial attenuation of PA5
% invoke(PA5,'ConnectPA5','USB',1);
% invoke(PA5,'SetAtten',50);
% %invoke(PA5,'SetAtten',99); %Set large attenuation to suppress noise by RP2 initialization process


RP2=actxcontrol('RPco.x',[5 5 26 26]);
invoke(RP2,'ConnectRP2','USB',1);
invoke(RP2,'ClearCOF');
invoke(RP2,'LoadCOF','random22.rcx');
invoke(RP2,'LoadCOFsf','random22.rcx',3);
% 0=6k=6103Hz 1=12k=12207Hz 2=25k=24414Hz 3=50k=48828Hz 4=100k=97656Hz
% 5=200k=195312Hz
invoke(RP2,'Run');

Fs=invoke(RP2,'GetSFreq')
%invoke(RP2,'SoftTrg',2)
Status=invoke(RP2,'GetStatus');

invoke(RP2,'SoftTrg',1);
% resulttone=invoke(RP2,'ReadTagV','resulttone',0,1000000);
% si=size(resulttone,2);
% plot([1:1:si],resulttone);hold off;
% assignin('base','resulttone',resulttone);
    