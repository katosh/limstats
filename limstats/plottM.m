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

function plottM(D,dias,xa,ya,lab,Labs,con,in,out,elim)
	
	Status="calculando ..."
	
	[x xla a] = asign(D,xa);
	
	x=x{1};
	
	if isempty(in)
		in = min(D.out);
	else
		in = confech(in);
	endif
	if isempty(out)
		out = max(D.in);
	else
		out = confech(out);
	endif
	
	if  (in > out)
		error('Fecha de comienzo debe estar mayor de la fecha de termino.');
	endif
	
	Status="selecion de datos ..."
	pos = (D.out>=in) & (D.in<=out) & !D.error;
	if ismember(lab,Labs)
		pos = pos & ismember(D.Lab,lab)';
	else
		lab = "todos los laboratorios";
	endif
	ind = find(pos);
	x = x(ind);
	
	[yt lege l]=asign(D,ya);
	
	% elije figure
	if isempty(lab) || !ismember(lab,Labs)
		n=1;
	else
		n = find(ismember(Labs,lab)) + 1;
	endif
	figure(n);
	
	hold off;
	
	maxi = 0;
	Status="calculado la aproximacion y distribucion ..."
	
	% aproximacion
	for i=1:l
		[yl rad xl]=approx(yt{i,1}(ind),x);
		plot(xl,yl,num2str(mod(i,7)));
		hold on;
		maxi = max(maxi,max(yl));
	endfor
	
	% por distribucion
	[tema dens temb]=approxa(x,x);
	
	% normalizacion de distribucion
	facto = ceil(max(dens)/maxi);
	dens = dens/facto;
	
	plot(xl,dens,num2str(mod(l+1,7)))
	stri=["distrinucion de ",xla{1}];
	lege{l+1,1}=stri;
	
	% regresion
	if con
		Status="calculando la regresion ..."
		[x y] = coarta(x,yt{l,i}(ind),elim);
		[nx ny coeff] = regression(x,y,500);
		%coeff
		tam = max(yl) - min(yl);
		maxi = max(yl) + (0.1*tam);
		%mini = min(yl) - (0.1*tam);
		ind = find((ny < maxi) & (ny > 0));
		nx=nx(ind);
		ny=ny(ind);
		plot(nx,ny,num2str(mod(i+2,7)));
		lege{l+2,1}="Regression";
		lab = [lab,"\n",lege{l,1}," converge hasta ",num2str(coeff(1))];
	endif
	lege{:,1};
	title(lab);
	legend(lege{:,1});
	xlabel(xla);
	hold off;
	
endfunction