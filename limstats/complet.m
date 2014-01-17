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

function [D timo] = complet(D)
	allLabs=unique(D.Lab);	
	l=length(D.Fin);
	p=0;
	stepsize = 5*l/100; % por display
	ab=clock;

		Status="interpretacion de fechas en muestras ..."
		%%%%% ... en bucle:
		for i=1:l
			temp = strptime([D.Fin{i}," ",D.Hin{i}],'%d/%m/%Y %T');
			% D.inDia{i} = strftime('%d-%m-%Y',temp);
			D.in(i)=mktime(temp);
			
			temp = strptime([D.Fp{i}," ",D.Hp{i}],'%d/%m/%Y %T');
			% D.sPDia{i} = strftime('%d-%m-%Y',temp);
			D.sP(i)=mktime(temp);
			
			temp = strptime([D.Ft{i}," ",D.Ht{i}],'%d/%m/%Y %T');
			% D.ePDia{i} = strftime('%d-%m-%Y',temp);
			D.eP(i)=mktime(temp);
			
			temp = strptime([D.Fpre{i}," ",D.Hpre{i}],'%d/%m/%Y %T');
			% D.outDia{i} = strftime('%d-%m-%Y',temp);
			D.pD(i)=mktime(temp);
			
			temp = strptime([D.Fout{i}," ",D.Hout{i}],'%d/%m/%Y %T');
			% D.outDia{i} = strftime('%d-%m-%Y',temp);
			D.out(i)=mktime(temp);
			
			% mostrar status:
			if (i >= p)
				p= i + stepsize;
				Status=[num2str(floor(100*i/l)),"%"]
			endif
		endfor
		
		Status="Correccion de unos datos ..."
		
		D=correctD(D,allLabs);
		
		%%%%% ... en vector
		D.dura = D.out - D.in;	
		D.duraLab = D.eP - D.sP;
		D.duraRec = D.sP - D.in;
		D.duraDes = D.out - D.eP;
		D.duraMas = D.duraRec + D.duraLab;
	
endfunction