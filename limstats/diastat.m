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

function diastat(D,dias,opt,lab,tipo,client,Labs,in,out,trab)

	Status = "calculando ..."
	pos = 1;

	try if isempty(trab)
		trab = 1;
	endif
	end_try_catch

	% selectar Lab
	try
		pos = pos & ismember(D.Lab,lab);
	end_try_catch

	% selectar cliente
	try
		pos = pos & ismember(D.Cliente,client);
	end_try_catch

	% selectar tipo
	try
		pos = pos & ismember(D.tipo,tipo);
	end_try_catch

	% sin datos con errores
	pos = pos & !D.error';

	% eliminar datos unselectado
	ind = find(pos);
	for [ val, nombre ] = D
		val = val(ind);
	endfor

	% obtener datos de obtiones selectado
	[opt name l]=optionen(opt,D);

	% creacion o conversion de fecha
	if isempty(in)
		in = min(opt{1,1});
	else
		in = confech(in);
	endif
	if isempty(out)
		out = max(opt{1,1});
	else
		out = confech(out);
	endif
	if  (in > out)
		error('Fecha de comienzo debe estar mayor de la fecha de termino.');
	endif

	% selecion de figure
	if isempty(lab)
		n=1;
		lab="Dia";
	else
		n = find(ismember(Labs,lab)) + 1;
	endif
	figure(n);
	hold off;

	% para factura de ocupacion
	maxx = 1;

	for i = 1:l

		try
			si = !isequal(name{i,1}(1:9),"ocupacion");
		catch
			si = true;
		end_try_catch

		% eleminar differenci de zonas de tiempo
		% queda un error de tiempo de
		temp = mktime(strptime("01/01/2010 00:00:00",'%d/%m/%Y %T'));
		diff = ((temp/86400) - floor(temp/86400))*86400;
		opt{i,1} = opt{i,1} - diff;

		if si
			data = elimdata(opt{i,1},D,dias,in,out,trab,lab,Labs);
			[x l] = dstat(data,dias,trab);
			[temp y xn] = approxa(x,x*24,1);
			y = y/l;
			maxx = max(maxx,max(y));

		else % ocupacion
			% opt{i,1} es D.in resepcion
			% opt{i,2} es D.eP end proceso
			[dataa indexa]=elimdata(opt{i,1},D,dias,in,out,trab,lab,Labs);
			ia = indexa;
			lena = length(ia);
			p = (opt{i,1}(ia)/86400) - floor(opt{i,1}(ia)/86400);
			du = (min(opt{i,2}(ia),out) - opt{i,1}(ia))/86400;

			% procesos que incresa antes "in"
			[datab indexb]=elimdata(opt{i,1}+opt{i,2},D,dias,in,out,trab,lab,Labs);
			ind = find(!ismember(indexb,indexa));
			ib = indexb(ind);
			lenb = length(ind);
			p(lena+1:lena+lenb) = 0;
			fin = min(opt{i,2}(ib), out);
			du(lena+1:lena+lenb) = (fin - in)/86400;


			% eliminar errores
			ind = find(du>0);
			p=p(ind);
			du=du(ind);

			j=0;
			res = 500;
			x = linspace(0,1,res);
			for m = x;
				ocu(++j) = sum(floor(p+du-m) + (m >= p));
			endfor

			l = numdias(dias,in,out,trab);
			try
				ocu=ocu/l;
			end_try_catch

			[y temp xn] = approx(ocu,x*24,1);

			% ocupacion relativa

			a = max(y);
			a = ceil(a);
			b = min(y);
			b = floor(b);
			g = a - b;
			if (g==0) g=1; endif
			y = ((y - b)/g)*1;
			%y = y / f;
			name{i,1}=[name{i,1}," ( [",num2str(a-g)," , ",num2str(a),"] --> [0 , 1] )"];
		endif
		plot(xn,y,num2str(mod(i,7)));
		hold on;
	endfor

	legend(name{:,1});
	title(lab);
	xlabel("hora");
	xtick=0:24;
	set(gca(),'xtick',xtick); % set tick pos. manually
	hold off;

endfunction
