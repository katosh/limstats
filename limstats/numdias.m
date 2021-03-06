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


% numero de los dias con el numero de secundos
function n = numdias(dias,in,out,trab)
	in = in/86400;
	out = out/86400;
	if trab
        % dias de trabajo sin noches
		dia = sort(unique(floor(dias.in/86400)));
		n = max(find(dia <= out)) - min(find(dia >= in));
	else
		n = floor(out) - floor(in);
	endif
endfunction
