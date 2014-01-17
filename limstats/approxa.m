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

function [app dens x] = approxa(y,x,base,rad)
% aproximatxion de datos con grafico continue 
% por Mediana sobre valores en radio rad

	l=length(y);
	lx=length(x);
	a=min(x);
	b=max(x);
	
	% correction de entrada
	try
		lb=length(base);
	catch
		lb=500;
		base=linspace(a,b,lb);
	end_try_catch
	if (lb == 1) || (lb == 0)
		rad = base;
		if (l != lx)
			base=x;
			lb=lx;
			x=1:l;
			lx=l;
		else
			lb=500;
			base=linspace(a,b,lb);
		endif
	endif
	
	% rad automatico
	if !exist("rad","var") || isempty(rad)
		rad = 5*(b-a)/100;
	endif
	
	% aproximacion
	for p = 1:lb
		temp=abs(x-base(p));
		pesos=(temp < rad) .* (rad - temp)/rad;
		Peso=sum(pesos);
		if Peso > 0
			app(p)=sum(pesos .* y)/Peso;
		else
			app(p)=0;
		endif
		dens(p)=Peso/rad;
	endfor
	
	x = base;
	
endfunction