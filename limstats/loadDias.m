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

function dias=loadDias
	[temp.F, temp.in, temp.out]=textread(
	["../Datos/tiempo_trabajo.csv"],
	"%s %s %s",
	"delimiter",";","headerlines",1);
	l=length(temp.in);
	stepsize = 10/100; % por display
	fact=1/l;
	ab=clock;
	p=0;
	for i=1:l
		dias.in(i) = mktime(strptime([temp.F{i}," ",temp.in{i}],'%d-%m-%Y %T'));
		dias.out(i) = mktime(strptime([temp.F{i}," ",temp.out{i}],'%d-%m-%Y %T'));
		%dias.F(i) = mktime(strptime(temp.F{i},'%d-%m-%Y'));

			% mostrar status:
			pos = i * fact;
			if (pos >= p)
				p= pos + stepsize;
				wa = (etime(clock, ab) / pos) * (1-pos);
				warten = strftime('%T',gmtime(wa));
				Status=[num2str(floor(pos*100)),"%"]
			endif

	endfor
	[dias.in i] = sort(dias.in');
	dias.out = dias.out'(i);
	dias.F = temp.F'(i);
endfunction
