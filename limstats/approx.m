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

function [app rado x] = approx(y,x,base,smoo)
% aproximatxion de datos con grafico continue 
% por Mediana sobre valores en radio dinamico

	Status="calculando la aproximacion ..."
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
		smoo = base;
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
	
	if !exist("smoo") || isempty(smoo)
		smoo = 10;
	endif
	
	% para monstrar status
	stepsize = 5/100;
	fact=1/lb;
	pa=0;
	ab=clock;
	
	% objetivo para Peso
	op=(smoo/100)*(l/2);
	% tolerancia
	tol=0.01;
	
	maxx=(b-a);
	
	% inicio de rad
	rad = maxx/2;
	step=rad/2;
	na=0;
	
	% primera tick
	prim=true;
		
	% aproximacion
	for p = 1:lb
	
		% distancia de valores
		dist=abs(x-base(p));
	
		Peso=inf;
		opc=op+sum(x==base(p));
		
		% cambiar signo
		cs=false;
		num=0;
		
		do
			num++;
			
			% radio nuevo
			if (num > 1) || !prim
				rad = rad +(step*((2*wn)-1));
			endif
			
			% pesos
			pesos=(dist < rad) .* (rad - dist);
			Peso=sum(pesos);
				
			% cambiar signo (cs) y direccion (wn)
			wn=(Peso<opc);
			if (num == 1) wa = wn; endif
			if (wa != wn) cs=true; endif
			wa=wn;
			
			% step mayor o menor
			if (cs || (num == 1)) && (step/2 != 0)
				step = step/2;
			elseif (num > 1)
				step = step*2;
			endif

		until(((Peso < (opc*(1+tol))) && (Peso > (opc*(1-tol)))) || (num==10))

		% doc de aproximacion
		if Peso > 0
			app(p)=sum(pesos .* y)/Peso;
		else
			app(p)=0;
		endif
		
		% doc de radio
		rado(p)=rad;
		
		prim=false;
		
		% mostrar status:
		%{
			pos = p * fact;
			if (pos >= pa)
				pa= pos + stepsize;
				wa = (etime(clock, ab) / pos) * (1-pos);
				warten = strftime('%T',gmtime(wa));
				Status=[num2str(floor(pos*100)),"%"]
			endif
		%}
	endfor
	
	x = base;
	
endfunction