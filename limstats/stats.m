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

function stats(D,dias,Lab,Labs,in,out)

	Status="buscando datos ..."

	labsq=Labs;
	nuevoi=false;
	nuevoo=false;
	ll=length(Labs);
	loops = 1:ll;

	% correct inputs
	if !isempty(Lab)
	if ismember(Lab,Labs)
		loops = find(ismember(Labs,Lab));
	else
		out = in;
		in = Lab;
	endif
	endif

	for i=loops
		try
		lab = Labs{i};
		Status="calculando ..."
		posis = ismember(D.Lab,lab)';
		ind = find(posis & !D.error);


		% correct missing dates
		if !exist("in") || isempty(in) || nuevoi
			in = strftime('%d/%m/%Y',localtime(min(D.in(ind))));
			nuevoi=true;
		endif
		if !exist("out") || isempty(out) || nuevoo
			out = strftime('%d/%m/%Y',localtime(max(D.out(ind))));
			nuevoo=true;
		endif


		% find intervall of dias
		[com tom] = confinout(in,out);
		c = min(find(dias.in > com));
		t = min(find(dias.out > tom));

		tage.F = sort(unique(dias.F(c:t)));
		l = length(tage.F);
		for i = 1:l
			ind = find(ismember(dias.F,tage.F(i)));
			tage.zeit(i) = sum(dias.out(ind)-dias.in(ind));
		endfor

		proc = posis & (D.sP >= com) & (D.eP <= tom);
		procE = find(proc & !D.error);
		proc = find(proc);

        termed_in_week = ismember(floor(D.eP/86400),floor(dias.in/86400));
        rec_in_week = ismember(floor(D.in/86400),floor(dias.in/86400));

		anzahl = length(proc); % numero de muestras
		anzahlT = sum(posis & (D.eP >= com) & (D.eP <= tom)); % numero de terminos
		anzahlTw = sum(termed_in_week & posis & (D.eP >= com) & (D.eP <= tom)); % numero de terminos
		anzahlR = sum(posis & (D.in >= com) & (D.in <= tom)); % numero de recepciones
		anzahlRw = sum(rec_in_week & posis & (D.in >= com) & (D.in <= tom)); % numero de recepciones
		%datMuestra(D,proc(1));
		%datMuestra(D,proc(2));
		%datMuestra(D,proc(3));
		duraT = mean(D.duraTrab(procE));
        duraTm = median(D.duraTrab(procE));
		duraR = mean(D.duraRec(procE));
		duraRm = median(D.duraRec(procE));
		dura = mean(D.dura(procE));
		duram = median(D.dura(procE));
		duraL = mean(D.duraLab(procE));
		duraLm = median(D.duraLab(procE));
		duraD = mean(D.duraDes(procE));
		duraDm = median(D.duraDes(procE));
		tiempoTrab = sum(tage.zeit);
		Frec = anzahlR / l;
		Frecw = anzahlRw / l;
		Fter = anzahlT / l;
		Fterw = anzahlTw / l;
		von = max(D.sP(proc),com);
		bis = min(D.eP(proc),tom);
		equipo = sum(duraTrabajo(dias,von,bis))/tiempoTrab;
		%equipo = mean(dias.ocu(i,c:t));
		ldia = mean(tage.zeit);
		ldiam = median(tage.zeit);
		try
			%duraTeorica = mean(D.duraTeorica(procE));
			[x y] = coarta(D.equipoRL(proc),D.duraTeorica(proc),[20 1 1 1]);
			[nx ny coeff] = regression(x,y,500);
			duraTeorica = coeff(1);

			if (coeff(2) < 0)
				printf("\n - comportamiento inesperado de laboratorio\n\n");
				duraTeorica = mean(D.duraTeorica(procE));
			endif
			if (duraTeorica <= 0)
				printf("\n - inposible calcular duracion teorica buena!\n\n");
				duraTeorica = mean(D.duraTeorica(procE));
			endif
			if (duraTeorica <= 0)
				printf("\n - inposible calcular duracion teorica!\n\n");
				error("");
			else
				capT = ldia/duraTeorica;
				ocup = ceil((Fter/capT)*100);
			endif
		catch
			duraTeorica = 0;
			capT = 0;
			ocup = 0;
		end_try_catch

		printf(["\n ----- Estatisticas para ",lab,": -----\n"]);
		printf(["\n Desde	-",in,"-	hasta	-",out,"-\n"]);
		printf(["\n Entera tiempo de trabajo:		",num2str(floor(tiempoTrab / 86400)),strftime(' dias y %R',gmtime(tiempoTrab))]);
		printf(["\n Muestras procesando entre este rato:	",num2str(anzahl)]);
		printf(["\n Recepcionadas:				",num2str(anzahlR)]);
		printf(["\n Terminaciones:				",num2str(anzahlT)]);
		printf(["\n Medio Terminaciones/dia con fin de semana como prima:		",num2str(Fter)]);
		printf(["\n Medio Terminaciones/dia en la semana:				",num2str(Fterw)]);
		printf(["\n Medio Recepcionadas/dia con fin de semana como prima:		",num2str(Frec)]);
		printf(["\n Medio Recepcionadas/dia en la semana:				",num2str(Frecw)]);
		printf(["\n Medio   duracion en Recepcion:		",num2str(floor(duraR / 86400)),strftime(' dias y %R',gmtime(duraR))]);
		printf(["\n Mediana duracion en Recepcion:		",num2str(floor(duraRm / 86400)),strftime(' dias y %R',gmtime(duraR))]);
		printf(["\n Medio   duracion de Muestra en Cesmec:	",num2str(floor(dura / 86400)),strftime(' dias y %R',gmtime(dura))]);
		printf(["\n Mediana duracion de Muestra en Cesmec:	",num2str(floor(duram / 86400)),strftime(' dias y %R',gmtime(dura))]);
		printf(["\n Medio   duracion en Laboratorio:	",num2str(floor(duraL / 86400)),strftime(' dias y %R',gmtime(duraL))]);
		printf(["\n Mediana duracion en Laboratorio:	",num2str(floor(duraLm / 86400)),strftime(' dias y %R',gmtime(duraL))]);
		printf(["\n Medio   duracion en Despacho:		",num2str(floor(duraD / 86400)),strftime(' dias y %R',gmtime(duraD))]);
		printf(["\n Mediana duracion en Despacho:		",num2str(floor(duraDm / 86400)),strftime(' dias y %R',gmtime(duraD))]);
		printf(["\n Medio   duracion de Trabajo en lab.:	",num2str(floor(duraT / 86400)),strftime(' dias y %R',gmtime(duraT))]);
		printf(["\n Mediana duracion de Trabajo en lab.:	",num2str(floor(duraTm / 86400)),strftime(' dias y %R',gmtime(duraT))]);
		printf(["\n Medio numero de equipo en proceso:	",num2str(equipo)]);
		printf(["\n Medio   duracion Teorica:		",num2str(floor(duraTeorica / 86400)),strftime(' dias y %R',gmtime(duraTeorica))]);
		printf(["\n Medio len de trabajo por dia:	",strftime('%R',gmtime(ldia))]);
		printf(["\n Mediana len de trabajo por dia:	",strftime('%R',gmtime(ldiam))]);
		printf(["\n Capacidad teorica:			",num2str(capT)," muestras/dia"]);
		printf(["\n Ocupacion:				",num2str(ocup)," %%"]);
		printf(["\n"]);
		catch
            %disp(["at file: ",lasterror.stack.file," line: ",lasterror.stack.line, " column :",lasterror.stack.column])
			printf([" ---- imposible hacer estatisticas para ",lab,"\n"]);
		end_try_catch
	endfor
endfunction
