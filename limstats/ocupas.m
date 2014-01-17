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

function dias = ocupas(D,dias,Labs)

Status="claculacion de ocupacion de laboratorios"

la = length(Labs);
l = length(dias.in);
stepsize = 5*l/100;
p=0;
ab=clock;
for i=1:la
	%temp = find(ismember(D.Lab,Labs{i})' & !D.errorF);
	temp = find(ismember(D.Lab,Labs{i})');
	if isempty(temp)
		labo{i}=-1;
	else
		labo{i}=temp;
	endif
endfor

for j = 1:l
	for i = 1:la
		if labo{i} != -1
			dia.in = dias.in(j);
			dia.out = dias.out(j);
			dialen = dias.out(j) - dias.in(j);
			dias.ocu(i,j) = sum(duraTrabajo(dia,D.in(labo{i}),D.eP(labo{i})))/dialen;
		else
			dias.ocu(i,j)=0;
		endif
	endfor
	dias.ocu(la+1,j)=sum(dias.ocu(1:la,j));
	
	if (j >= p)
		p = j + stepsize;
		per=j/l;
		wa = (etime(clock, ab) / per) * (1-per);
		warten = strftime('%T',gmtime(wa));
		Status=[num2str(floor(per*100)),"%"]
	endif
endfor
Status = "listo"
endfunction