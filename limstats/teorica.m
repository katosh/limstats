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

function D = teorica(D,dias,Labs)

	l=length(D.Fin);
	ab=clock;
	p=0;
	j=0;
	stepsize = l/100;

% encontra muestras validas

		Status="calculacion duracion teorica..."
		t=zeros(1,l);
		tr=zeros(1,l);
		D.equipoRL=ones(1,l);
		
		% ordenar para mejor persentaje de "Status"
		for k = 1:length(Labs)
			%tamlab(k) = sum((ismember(D.Lab,Labs{k})' & !D.error) .* D.duraMas);
			tamlab(k) = sum(ismember(D.Lab,Labs{k})' .* (D.duraMas + D.duraTrab));
		endfor
		[temp ind] = sort(-tamlab);
		Labs = Labs(ind);
		
		for k = 1:length(Labs)
			% find all Muestras of one lab
			%labo = ismember(D.Lab,Labs{k})' & !D.error;
			labo = ismember(D.Lab,Labs{k})';
			ind = find(labo);
			
			% calculacion de numero de equipo en lab durante proceso
			for i = ind
				
				if (D.duraTrab(i) <= 0)
					D.equipoEnLab(i) = sum((D.sP(ind) <= D.sP(i)) & (D.eP(ind) >= D.sP(i)));
					t(i)=0;
					D.equipoRL(i) = sum((D.in(ind) <= D.sP(i)) & (D.eP(ind) >= D.sP(i)));
					tr(i)=0;
				else
					id = (D.sP(ind) < D.eP(i)) & (D.eP(ind) > D.sP(i));
					von = max(D.sP(ind)(id),D.sP(i));
					bis = min(D.eP(ind)(id),D.eP(i));
					t(i) = sum( duraTrabajo(dias,von,bis) );
					
					id = (D.in(ind) < D.eP(i)) & (D.eP(ind) > D.sP(i));
					von = max(D.in(ind)(id),D.sP(i));
					bis = min(D.eP(ind)(id),D.eP(i));
					tr(i) = sum( duraTrabajo(dias,von,bis) );
				endif
				%D.test(i)=sum((D.sP(ind) <= D.sP(i)) & (D.eP(ind) >= D.sP(i)));
				
				% mostrar persentaje
				if (++j >= p)
					p = j + stepsize;
					per=j/l;
					wa = (etime(clock, ab) / per) * (1-per);
					warten = strftime('%T',gmtime(wa));
					Status=[num2str(floor(per*100)),"% espere apr. ",warten]
					%Labs{k}
				endif
				
			endfor
		endfor
	
		%ind = find((D.duraTrab > 0) & !D.error);
		ind = find(D.duraTrab > 0);
			D.equipoEnLab(ind) = t(ind) ./ D.duraTrab(ind);
			D.equipoRL(ind) = tr(ind) ./ D.duraTrab(ind);
			
		%ind = find(!D.error);
		%	D.duraTeorica(ind) = D.duraTrab(ind) ./ D.equipoEnLab(ind);
		D.duraTeorica = D.duraTrab ./ D.equipoEnLab;
		D.duraTeoR = D.duraTrab ./ D.equipoRL;
		
		%Status="Saltarse de errores"
		Status="listo"
	
endfunction