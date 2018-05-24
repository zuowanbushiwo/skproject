function [x1,y1,x2,y2,xc,yc,si,so,dtInfo] = dspblkvqenc(action)
% DSPBLKVQENC DSP System Toolbox Vector quantization encoder block mask helper function.
% Copyright 1995-2005 The MathWorks, Inc.
%

if nargin==0, action = 'dynamic'; end

blk = gcb;
blkh   = gcbh;
puCB_SRCval = get_param(blkh, 'CBsource');
switch action

case 'icon'
    dtInfo = dspGetFixptDataTypeInfo(blkh,13);
  %%%Draw voronoi cells with centroids%%
    x1=[ 0.52 0.55 0.70 0.78 NaN  0.78 0.65 0.48 0.46 NaN 0.20 0.38 0.35 0.20]-0.04;
	y1=[ 0.15 0.40 0.50 0.43 NaN  0.85 0.65 0.72 0.93 NaN 0.80 0.67 0.50 0.35]-0.15;
	x2 = [x1(3) x1(7) NaN x1(8) x1(12) NaN x1(13) x1(2)];
	y2 = [y1(3) y1(7) NaN y1(8) y1(12) NaN y1(13) y1(2)];

	% circles
	S=8; t=(0:S)'/S*2*pi; a=0.01;
	xcos=a*cos(t);ysin=a*sin(t);

	xc=xcos*ones(1,7) + ones(size(t))*[[.72 .80 .65 .41  0.32  0.40 0.59]-0.1];
	yc=ysin*ones(1,7) + ones(size(t))*[[.30 .60 .80 .80  0.60  0.30 0.55]-0.15];

  %%%%%
  cbOUTERRval = get_param(blkh,'outQError');
  cbOUTQUval  = get_param(blkh,'outQU');
  puDISTMEASval = get_param(blkh, 'distMeasure');
  puWGTSRCval   = get_param(blkh, 'wgtSrc');
	i = 1;
	j = 1;
    % input ports
	si(i).port = i;
	si(i).txt = 'U';
	if strcmp(puCB_SRCval, 'Input port'),
        i=i+1;
        si(i).port = i;
        si(i).txt = 'C';
	end
    if strcmp(puDISTMEASval, 'Weighted squared error') && ...
       strcmp(puWGTSRCval, 'Input port')
        i=i+1;
        si(i).port = i;
        si(i).txt = 'W';
    end
    % output ports
	so(1).port = 1;
	so(1).txt = 'I';
	if strcmp(cbOUTQUval, 'on'),
        j = j + 1;
        so(j).port = 2;
        so(j).txt = 'Q(U)';
	end
	if strcmp(cbOUTERRval, 'on'),
        j = j + 1;
        so(j).port = j;% 2 or 3
        so(j).txt = 'D';
	end

for m=i+1:3, si(m)=si(i); end
for n=j+1:3, so(n)=so(j); end

case 'dynamic'
  % Execute dynamic dialogs
  mask_enables     = get_param(blkh, 'MaskEnables');
  old_mask_enables = mask_enables;

  % prefix: pu=pop-up, eb=edit box, cb=check box
  [puCB_SRC,ebCB,puDISTMEAS,puWGTSRC, ebWEIGHTS,puTIE,cbOUTQU, cbOUTQERR, ...
   cbADDI, puIDXDTYPE] = deal(1,2,3,4,5,6,7,8,9,10);

  puDISTMEASval = get_param(blkh, 'distMeasure');

  ALWAYS_ON_ITEMS = [puCB_SRC puTIE puDISTMEAS puWGTSRC cbOUTQU cbOUTQERR ...
                     puIDXDTYPE];
  mask_enables(ALWAYS_ON_ITEMS) = {'on'};
  if strcmp(puCB_SRCval, 'Specify via dialog'),
      mask_enables{ebCB}  = 'on';
  else
      mask_enables{ebCB}  = 'off';
  end

  if strcmp(puDISTMEASval, 'Squared error'),
       mask_enables{puWGTSRC}   = 'off';
       mask_enables{ebWEIGHTS}  = 'off';
  else %Weighted squared error
       mask_enables{puWGTSRC}   = 'on';
       puWGTSRCval   = get_param(blkh, 'wgtSrc');
       if strcmp(puWGTSRCval, 'Specify via dialog')
           mask_enables{ebWEIGHTS}   = 'on';
       else % from input port
           mask_enables{ebWEIGHTS}   = 'off';
       end
  end
  [mask_enables,old_mask_enables] = dspProcessFixptMaskParams(blkh, mask_enables,old_mask_enables);

  if (~isequal(mask_enables, old_mask_enables))
      set_param(blkh, 'MaskEnables', mask_enables);
  end
end % end of switch statement

% [EOF] dspblkvqenc.m
