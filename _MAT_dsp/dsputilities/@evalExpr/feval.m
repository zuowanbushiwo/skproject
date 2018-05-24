function varargout = feval(varargin)
%FEVAL  FEVAL an evalExpr object.

% Copyright 1995-2011 The MathWorks, Inc.

INLINE_OBJ_ = varargin{1};
INLINE_INPUTS_ = varargin(2:end);
if isempty(INLINE_OBJ_.expr),
    INLINE_OUT_ = [];
else
    % Need to evaluate expression in a function outside the @inline directory
    % so that f(x), where f is an inline in the expression, will call the
    % overloaded subsref.
    INLINE_OUT_ = local_eval(INLINE_INPUTS_, INLINE_OBJ_.inputExpr, INLINE_OBJ_.expr);
end
varargout{1} = INLINE_OUT_;

% ------------------------------------
function INLINE_OUT_ = local_eval(INLINE_INPUTS_, INLINE_INPUTEXPR_, INLINE_EXPR_)
% INLINEEVAL Evaluate an inline object expression.
%    Utility function to evaluate expression in a function outside the 
%    @inline directory so that f(x), where f is an inline in the expression, 
%    will call the overloaded subsref for inline objects.

INLINE_OUT_ = [];
eval(INLINE_INPUTEXPR_);
try
    INLINE_OUT_ = eval(INLINE_EXPR_);
catch Err
    error(message('dsp:inlineeval:InlineExprError', INLINE_EXPR_, Err.message));
end

% [EOF] $File: $
