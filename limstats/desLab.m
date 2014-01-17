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

function [rec term dura ocu] = desLab(D,dias,lab,Labs)

		l=length(dias.in);
		stepsize = 10*l/100;
		posi=0;
		
		rec=zeros(1,l);
		term=zeros(1,l);
		dura=zeros(1,l);
		ocu=zeros(1,l);

		% selectar lab o todos
		if isempty(lab)
			lab = "deserrollo";
			i=1:length(D.in);
			% numero de lab por ocu:
			ln = length(Labs)+1;
		else
			i = find(ismember(D.Lab,lab)');
			% numero de lab para ocu:
			ln = find(ismember(Labs,lab));
		endif
		
		Status = ["Calculacion de ",lab," ..."]
		
		for (j = 1:l)
			
			% encontrar mismo dias con floor(dias(i)/86400) == floor(DIA/86400)
			rec(j) = sum(floor(D.in(i)/86400) == floor(dias.in(j)/86400));
			ind = find((floor(D.eP(i)/86400) == floor(dias.in(j)/86400)) & !D.error(i));
			if !isempty(ind) 
				dura(j) = mean(D.duraMas(i)(ind)); 
			else
				try
					dura(j) = dura(j-1);
				end_try_catch
			endif
			term(j) = sum(floor(D.eP(i)/86400) == floor(dias.in(j)/86400));
			%von = max(D.sP(i),dias.in(j));
			%bis = min(D.eP(i),dias.out(j));
			%ocu(j) = sum(duraTrabajo(dias,von,bis))/(dias.out(j)-dias.in(j));
			try
				ocu(j)=dias.ocu(ln,j);
			catch
				ocu(j)=0;
			end_try_catch
			
			if (posi <= j)
				posi = j + stepsize;
				Status = [num2str(floor((j/l)*100)),"%"]
			endif
			
		endfor
		%temp.in = D.sP(i);
		%temp.out = D.eP(i);
		% ocu = duraTrabajo(temp,dias.in,dias.out) / (dias.out-dias.in);
		dura=dura/86400; % normalizacion a dias
	endfunction