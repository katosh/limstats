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

function i=datMuestra(D,i)
o=i;
if !isnumeric(i)
	text=i;
	i=find(ismember(D.muestra,text));
	if isempty(i)
		text=strrep(text,"-","");
		text=strrep(text,"m","M-");
		i=find(ismember(D.muestra,text));
	endif
endif

if isempty(i)
	disp([o," no encontrada."]);
	input("presione entre ...",'s');
else
	for [ val, nombre ] = D
		if iscell(val(i))
			disp([nombre,":	",val{i}]);
		else
			disp([nombre,":	", num2str(val(i))]);
		endif
	endfor
endif

endfunction