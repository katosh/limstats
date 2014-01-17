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

function [y l] = dstat(daten,dias,trab)

% eleminar differenci de zonas de tiempo
% queda un error de tiempo de 
temp = mktime(strptime("01/01/2010 00:00:00",'%d/%m/%Y %T'));
diff = (temp/86400) - floor(temp/86400);
daten = daten - diff;

ym = daten/86400;
yf = floor(ym);
		
	if trab
		df = floor(dias.in/86400);
		ind = find(ismember(yf,df));
		l = max(find(df <= max(yf))) - max(find(df <= min(yf)));
		y = (ym(ind) - yf(ind));
	else
		l = max(yf) - min(yf);
		y = (ym - yf);
	endif
	
endfunction