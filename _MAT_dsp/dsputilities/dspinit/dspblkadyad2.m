function [hl,hh,x,y,str] = dspblkadyad2(varargin)
% DSPBLKADYAD Mask dynamic dialog function for dyadic
% filter block

% Copyright 1995-2011 The MathWorks, Inc.

if nargin==0
   action = 'dynamic';   % mask callback
else
   action = 'setup';
end
   
switch action
      
   case 'setup'
      % If values are unspecified, continue on so that an icon
      % will still be drawn.
      hl = varargin{1};
      [M,N] = size(hl);
      if (M == 1 |  N == 1)
          % Need to reshuffle the coefficients into phase order
          D = 2;
          len = length(hl);
          hl = flipud(hl(:));
          if (rem(len, D) ~= 0)
              nzeros = D - rem(len, D);
              hl = [zeros(nzeros,1); hl(:)];
          end
          len = length(hl);
          nrows = len / D;
          % Re-arrange the coefficients
          hl = flipud(reshape(hl, D, nrows).');
      end
      
      hh = varargin{2};
      [M,N] = size(hh);
      if (M == 1 | N == 1)     
          D = 2;
          len = length(hh);
          hh = flipud(hh(:));
          if (rem(len, D) ~= 0)
              nzeros = D - rem(len, D);
              hh = [zeros(nzeros,1); hh(:)];
          end
          len = length(hh);
          nrows = len / D;
          % Re-arrange the coefficients
          hh = flipud(reshape(hh, D, nrows).');
      end
      
      % Create the icon
      numLevels = varargin{3};
      if (isempty(numLevels) | ~isfinite(numLevels) | ~isnumeric(numLevels) | numLevels < 1)
         numLevels = 2;
      end
      if (varargin{4} == 2)
         symmetric = 1;
      else
         symmetric = 0;
      end
      
      if (symmetric == 1)
         dx = (1.0 - 0.1) / (numLevels+1);
         [x1,y1] = recursive_icon(1, numLevels, 0.05+dx, 0.5);
         % Draw the arrowhead
         x0 = 0.05;
         x(1) = x0;            y(1) = 0.5;
         x(2) = dx;            y(2) = 0.5;
         x(3) = x0 + 0.8*dx;   y(3) = 0.5;
         x(4) = x0 + 0.2*dx;   y(4) = 0.4;
         x(5) = x0 + 0.2*dx;   y(5) = 0.6;
         x(6) = x0 + 0.8*dx;   y(6) = 0.5;
         x0 = x0 + dx;
         x(7) = x0;            y(7) = 0.5;
         x = [x x1];
         y = [y y1];

      else
         dx = (1.0 - 0.1) / (numLevels+1);
         dy = (1.0) / (numLevels+1);
         x0 = 0.05;
         y0 = 1.0-dy*.5;
         % Draw the arrowhead
         x(1) = x0;            y(1) = y0;
         x(2) = 0.95;          y(2) = y0;
         x(3) = x0 + 0.8*dx;   y(3) = y0;
         x(4) = x0 + 0.2*dx;   y(4) = y0 + 0.3*dy;
         x(5) = x0 + 0.2*dx;   y(5) = y0 - 0.3*dy;
         x(6) = x0 + 0.8*dx;   y(6) = y0;
         x0 = x0 + dx;
         x(7) = x0;            y(7) = y0;
         y0 = y0 - dy;
         for k=0:numLevels-1
            m = 3*k+8;
            x(m) = x0;      y(m) = y0;
            x(m+1) = 0.95;  y(m+1) = y0; 
            x0 = x0 + dx;
            x(m+2) = x0;    y(m+2) = y0;
            y0 = y0 - dy;
         end
      end
     
      str = num2str(numLevels);
      
   otherwise
      error(message('dsp:dspblkadyad2:unhandledCase'));
   end
   
function [x, y] = recursive_icon(level, numLevels, x0, y0)
dx = (1.0 - 0.1) / (numLevels+1);
dy = 0.5 / (round(2^level));
x1(1) = x0;			y1(1) = y0 + dy;
x1(2) = x0 + dx;	y1(2) = y0 + dy;
if (level < numLevels)
   [x2, y2] = recursive_icon(level+1, numLevels, x0+dx, y0+dy);
else
   x2 = [];  y2=[];
end
x3(1) = x0;			y3(1) = y0 + dy;
x3(2) = x0;			y3(2) = y0 - dy;
x3(3) = x0+dx;		y3(3) = y0 - dy;
if (level < numLevels)
   [x4, y4] = recursive_icon(level+1, numLevels, x0+dx, y0-dy);
else
   x4 = [];  y4= [];
end
x5(1) = x0;			y5(1) = y0 - dy;
x5(2) = x0;			y5(2) = y0;
x = [x1 x2 x3 x4 x5];
y = [y1 y2 y3 y4 y5];

% end of dspblkadyad.m
