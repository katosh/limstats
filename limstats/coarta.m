% This file is part of limstats written by Dominik Otto.

% limstats is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

% limstats is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with limstats.  If not, see <http://www.gnu.org/licenses/>.

function [x y] = coarta(x,y,elim);

	lx = length(x);
	pxa = floor((elim(1)/100)*lx);
	pxe = floor((elim(2)/100)*lx);

	for i=1:pxa
		[a j] = min(x);
		x(j)=[];
		y(j)=[];
	endfor
	for i=1:pxe
		[a j] = max(x);
		x(j)=[];
		y(j)=[];
	endfor
	
	ly = length(y);
	pya = floor((elim(3)/100)*ly);
	pye = floor((elim(4)/100)*ly);
	
	for i=1:pya
		[a j] = min(y);
		x(j)=[];
		y(j)=[];
	endfor
	for i=1:pye
		[a j] = max(y);
		x(j)=[];
		y(j)=[];
	endfor
endfunction