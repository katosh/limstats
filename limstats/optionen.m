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

function [opti leg len] = optionen(opt,D);
	
	l=length(opt);
	
	%Offset
	of=0;
	
	for i = 1:l
		switch(opt(i))
			case "r"
				opti{i-of,1} = D.in;
				leg{i-of,1}="recepcionadas/h";
			case "i"
				opti{i-of,1} = D.sP;
				leg{i-of,1}="ingresadas a proceso/h";
			case "o"
				opti{i-of,1} = D.in;
				opti{i-of,2} = D.eP;
				leg{i-of,1}="ocupacion relativa";
			case "t"
				opti{i-of,1} = D.eP;
				leg{i-of,1}="terminados/h";
			case "p"
				opti{i-of,1} = D.pD;
				leg{i-of,1}="predespachadas/h";
			case "d"
				opti{i-of,1} = D.out;
				leg{i-of,1}="despachadas/h";
			otherwise
				++of;
		endswitch
	endfor
	len = length(leg(:,1));
	
endfunction