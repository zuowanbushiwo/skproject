function [s] = dspblkrls(action, varargin)
% DSPBLKRLS Mask dynamic dialog function for RLS adaptive filter
% Copyright 1995-2011 The MathWorks, Inc.
%  

blk=gcb;
s=[];
if nargin==0, action = 'init'; end
switch action
   case 'init'
     updateLambdaPort(blk);
     updateAdaptPort(blk);
     updateResetPort(blk);
     updateweightsoutput(blk);
    Checkforgettingfactor(varargin{2});
    CheckFilterLength(varargin{1});
     CheckandSetICs(blk, varargin{3});
  case 'addparams' %called when step size input option is changed
      AddParams(blk);
  otherwise % should not come here
      error(message('dsp:dspblkrls:unhandledCase'));
end

% -----------------------------------------------
function AddParams(blk)
LAMBDA = 3;
origmaskvis = get_param(blk,'MaskVisibilities');
wantLambdaPort = strcmp(get_param(blk, 'lambdaflag'),'Input port');
newflags = {'on', 'on', 'on', 'off', 'on', 'on', 'on', 'on', 'on'};
if wantLambdaPort
    newflags{LAMBDA} = 'off';
else
    newflags{LAMBDA} = 'on';
end
if ~isequal(origmaskvis, newflags)
    set_param(blk, 'MaskVisibilities', newflags);
end

% -----------------------------------------------
function updateLambdaPort(blk)
% Manage the "lambdaflag" feature
% Make port appear if user wants Lambda as input
% Make port disappear if user does not want step size as input.
%

% ltep port will always be 4th port in 'for' system and
% third port in the LMS block

lambdaBlk      = [blk '/Lambda'];
isLambdaPortPresent = strcmp(get_param(lambdaBlk,'BlockType'),'Inport');
wantLambdaPort      = strcmp(get_param(blk,'lambdaflag'),'Input port');
if wantLambdaPort && ~isLambdaPortPresent,
    % Change Constant to Port
    pos = get_param(lambdaBlk,'Position');
    delete_block(lambdaBlk);
    
    add_block('built-in/Inport',lambdaBlk, ...
              'Position', pos, ...
              'Port', '3');

elseif ~wantLambdaPort && isLambdaPortPresent,
    % Change Port to Constant
    pos = get_param(lambdaBlk,'Position');
    delete_block(lambdaBlk);
    add_block('built-in/Constant',lambdaBlk, ...
              'Position',pos,...
              'Value', 'lambda',...
              'OutDataTypeStr', 'Inherit: Inherit via back propagation');
end

% -----------------------------------------------
function updateAdaptPort(blk)
% Manage the "adapt" feature
% Make port appear if user wants adaptation-hold control
% Make port disappear if user does not want control over this
%
% Practically, this is performed by swapping a constant block
% for a port, and vice-versa

% The adapt port at the top will be either 3rd or 4th port depending on the
% presence of the step port. 

adaptBlk      = [blk '/Adapt'];
isAdaptPortPresent = strcmp(get_param(adaptBlk,'BlockType'),'Inport');
wantAdaptPort      = strcmp(get_param(blk,'Adapt'),'on');
if wantAdaptPort && ~isAdaptPortPresent,
    % Change Constant to Port
    pos = get_param(adaptBlk,'Position');
    delete_block(adaptBlk);
    
    % Note: this can be either the 3rd or 4th depending
    %   on whether the step port is present or not.
    %   You have to specify the port number accordingly.
    %  
    
    lambdaBlk = [blk '/Lambda'];
    isLambdaPortPresent = strcmp(get_param(lambdaBlk,'BlockType'),'Inport');
    portnum = num2str(3+isLambdaPortPresent);

    add_block('built-in/Inport',adaptBlk, ...
              'Position', pos, ...
              'Port', portnum);

elseif ~wantAdaptPort && isAdaptPortPresent,
    % Change Port to Constant
    pos = get_param(adaptBlk,'Position');
    delete_block(adaptBlk);
    add_block('built-in/Constant',adaptBlk, ...
              'Position',pos,'Value', ...
              'boolean(1)');
end

% -----------------------------------------------
function updateResetPort(blk)
% Manage the "reset" feature
% Make port appear if user wants to reset
% Make port disappear if user does not want control over this
%
% Practically, this is performed by swapping a constant block
% for a port, and vice-versa

% reset port will always be the last input port
resetBlk = [blk '/Reset'];
isResetPortPresent = strcmp(get_param(resetBlk,'BlockType'),'Inport');
resetMode = get_param(blk,'resetflag');  % Get popup state
wantResetPort = ~strcmp(resetMode,'None');

% Adjust ports/constants
if wantResetPort && ~isResetPortPresent,
    % Change Constant to Port
    pos = get_param(resetBlk,'Position');
    delete_block(resetBlk);

    add_block('built-in/Inport',resetBlk, ...
              'Position',pos);
          
elseif ~wantResetPort && isResetPortPresent,
    % Change Port to Constant
    pos = get_param(resetBlk,'Position');
    delete_block(resetBlk);
    add_block('built-in/Constant',resetBlk, ...
              'Position',pos, ...
              'Value','boolean(0)');
end

cr = sprintf('\n');
% Update reset mode of unit delay block:
delayBlk = [blk '/Frame-Based' cr 'RLS Filter/Filter Taps'];
corrBlk = [blk '/Frame-Based' cr 'RLS Filter/Update/Correlation'];
currentResetMode = get_param(delayBlk,'reset_popup');
% Don't turn off reset mode - in 'None' mode, we leave
% it at "Non-zero sample" with a constant-0 input.
if strcmp(resetMode,'None'),
    resetMode='Non-zero sample';
end
if ~strcmp(currentResetMode, resetMode),
    set_param(delayBlk,'reset_popup',resetMode);
    set_param(corrBlk,'reset_popup',resetMode);
end

%----------------------------------------------------------
function updateweightsoutput(blk)

cr = sprintf('\n');
%update weight output
weights = get_param(blk, 'weights');
if (strcmp(weights, 'off'))
    %first delete at the upper level
    if (exist_block(blk, 'Wts'))      
        delete_line(blk, ['Frame-Based' cr 'RLS Filter/3'], 'Flip/1');
        delete_line(blk, 'Flip/1', 'Wts/1');
        delete_block([blk '/Flip']);
        delete_block([blk '/Wts']);
        set_param([blk , '/Frame-Based' cr 'RLS Filter'], 'weights_for', 'off');
    end
else
    set_param([blk , '/Frame-Based' cr 'RLS Filter'], 'weights_for', 'on');
    if ~(exist_block(blk, 'Wts'))
        load_system('dspindex');
        add_block('dspindex/Flip', [blk '/Flip'], 'Position', [470 212 495 248]);
        add_block('built-in/Outport', [blk, '/Wts'], 'Position', [520 223 550 237]);
        add_line(blk, ['Frame-Based' cr 'RLS Filter/3'], 'Flip/1');
        add_line(blk, 'Flip/1', 'Wts/1');
    end
end


% -----------------------------------------------
function Checkforgettingfactor(lambda)
%Checks validity of the leakage parameter

if (lambda < 0 || lambda > 1)
    error(message('dsp:dspblkrls:paramOutOfRange'));
end
% -----------------------------------------------
function CheckFilterLength(L)
%Checks validity of the filter length parameter
if (L < 0 || (round(L) ~= L))
    error(message('dsp:dspblkrls:invalidFilterOrder'));
end

% -----------------------------------------------
function CheckandSetICs(blk, ic)
%Checks the length of ic and sets the parameter in the delay block
%accordingly
cr = sprintf('\n');
if (length(ic) > 1)
    set_param([blk '/Frame-Based' cr 'RLS Filter/Filter Taps'],...
        'dif_ic_for_ch', 'on');
else
    set_param([blk '/Frame-Based' cr 'RLS Filter/Filter Taps'],...
        'dif_ic_for_ch', 'off');
end

% [EOF] dspblkrls.m
