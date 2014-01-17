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

function [in out] = enterDate
	in = -1;
	out = -1;
	fin = 0;
	do
		in = input("Desde:	",'s');
		if getDate(in) == -1 && !isempty(in)
			printf("Formato no valida.\n");
		else
			fin = 1;
		endif
	until fin
		fin = 0;
	do
		out = input("Hasta:	",'s');
		if getDate(out) == -1 && !isempty(out)
			printf("Formato no valida.\n");
		else
			fin = 1;
		endif
	until fin
endfunction