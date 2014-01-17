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

function D = correctD(D,Labs)

% encontrar errores y muestras sin errores
		noerr = (D.out != -1) & (D.in != -1) & (D.sP != -1) & (D.eP != -1);
		D.errorF = !noerr;
		noerr = noerr & (D.in <= D.sP) & (D.sP <= D.eP) & (D.eP <= D.out);
		D.error = !noerr;
	
		% encontrar errores
		for k = 1 : length(Labs)
			lab = Labs{k};
			theLab = ismember(D.Lab,lab)';
			
			% encontrar medianas para correcion
			ind = find(theLab & noerr);
			if isempty(ind)
				medi=zeros(1,4);
				mediR = 0.5;
			else
				medi(1)=mean(D.eP(ind) - D.in(ind));
				medi(2)=mean(D.eP(ind) - D.sP(ind));
				medi(3)=mean(D.eP(ind) - D.out(ind)); % negativo
				medi(4)=mean(D.sP(ind) - D.in(ind));
				mediR = mean((D.eP(ind) - D.sP(ind))./(D.eP(ind) - D.in(ind)));
			endif
			
			% encontrar y corregir erroes en .eP
			posi = theLab & (D.eP==-1);
			pos{2} = posi & (D.sP != -1);
			pos{1} = posi & (D.in != -1) & !pos{2};
			pos{3} = posi & (D.out != -1) & !pos{1} & !pos{2};
			D.eP(find(pos{1})) = D.in(find(pos{1})) + medi(1);
			D.eP(find(pos{2})) = D.sP(find(pos{2})) + medi(2);
			D.eP(find(pos{3})) = D.out(find(pos{3})) + medi(3);
			
			% correccion .sP donde .in parece correcto
			ind = find(theLab & (D.sP == -1) & (D.in != -1) & (D.in <= D.sP));
				D.sP(ind) = D.eP(ind) - (mediR * (D.eP(ind) - D.in(ind)));
			
			% correccion .sP
			ind = find(theLab & ((D.sP == -1)|(D.sP > D.eP)));
				D.sP(ind) = D.eP(ind) - medi(2);
				
			% correccion .out
			ind = find(theLab & ((D.out == -1)|(D.out < D.eP)));
				D.out(ind) = D.eP(ind) - medi(3);
				
			% correccion .in
			ind = find(theLab & ((D.in == -1)|(D.in > D.sP)));
				D.in(ind) = D.sP(ind) - medi(4);

		endfor	

endfunction