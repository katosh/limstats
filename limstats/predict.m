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

function predict(D,dias,Lab,Labs,in,out,bis,pro,zeit)
	
	Status="buscando datos ..."
	
	labsq=Labs;
	nuevoi=false;
	nuevoo=false;
	ll=length(Labs);
	loops = 1:ll;
	
	% persentaje para intervallo confidencia
	if isempty(pro)
		pro = 90;
	endif
	
	% dias de terminar procesos
	if isempty(zeit)
		zeit=9;
	endif
	
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
		
		ldia = mean(tage.zeit);
		[temp i] = min(abs(tage.zeit-ldia));
		norm = tage.zeit(i); % duracion de trabajo en dia normal
		
		proc = posis & (D.in >= com) & (D.eP <= tom);
		procE = find(proc & !D.error);
		proc = find(proc);

		[x y] = coarta(D.equipoRL(proc),D.duraTeorica(proc),[20 1 1 1]);
		[nx ny coeff] = regression(x,y,500);

		if ((coeff(2) < 0) || (coeff(1) < 0))
			printf("\n ---- Laboratorio comporta inesperadamente. No se puede obtener una prediccion buna. ----\n\n");
		endif
		
		if isempty(bis)
			bis = 1.1 * max(D.equipoRL(proc));
		endif
		equi = linspace(1,bis,500);
		
		frec = norm./(coeff*cof(equi)); % terminaciones por dia
		
		
		% correction de percepccion con medianas
		% von = max(D.in(proc),com);
		% bis = min(D.eP(proc),tom);
		% tiempoTrab = sum(tage.zeit);
		% mequi = sum(duraTrabajo(dias,von,bis))/tiempoTrab; % mediana numero de equipo
		% anzahlT = sum(posis & (D.eP >= com) & (D.eP <= tom)); % numero de terminos
		% Fter = anzahlT / l;	% mediana frequencia
		% fn = norm./(coeff*cof(mequi)); % frequencia predictado
		% corection1 = Fter/fn;
		% corection2 = Fter - fn;
		% frec = frec*corection1; 
		% frec = frec + corection2;
		
		frec = frec .* (frec > 0);
		
		
		% duracion
		ind = find(frec > 0);
		dura = equi;
		dura(ind) = equi(ind)./frec(ind);
		% dura = equi./frec;
		
		% normalisacion para grafico mejor
		% fac = floor(max(frec) / max(dura));
		% if (fac==0) fac = 1; endif
		% frec = frec / fac;
		
		% regression linear de duracion en lab. mas rec.
		testdura = D.duraTrabM(proc)/norm;
		u(1,:) = ones(length(D.equipoRL(proc)),1);
		u(2,:) = D.equipoRL(proc);
		y = testdura;
		coffi = y/u;
		v(1,:) = ones(length(equi),1);
		v(2,:) = equi;
		dura2 = coffi*v;
		
		% grafico de datos real
		[y temp x]=approx(y,u(2,:));
		
		% correction con medianas
		%correction = mean(dura2-dura);
		%dura = dura + correction;
		%frec = equi./dura;
		
		frec2 = equi./dura2;
		
		% normalisacion para grafico mejor
		% fac = floor(max(frec2) / max(dura2));
		% if (fac==0) fac = 1; endif
		% frec2 = frec2 / fac;
		
		% calculacion de distribucion de error
		[equical i] = sort(D.equipoRL(proc));
		calca = equical./(norm./(coeff*cof(equical)));
		%calca = fliplr(cummin(fliplr(D.equipoRL(proc)./norm./(coeff*cof(D.equipoRL(proc))))));
		err = testdura(i) - calca;
		errn = sort(err)(1:ceil(0.99*length(err)));	% elimar errores grandes para grafico mejor
		[temp derr xerr]=approxa(errn,errn);
		
		% calculacion de intervallo de confidencia de error
		mitte = mean(err);
		per = ceil((pro/100)*length(err));
		%[temp i] = sort(abs(err - mitte));
		[temp i] = sort(err);
		% ci = min(err(i)(1:per));
		ci = min(err);
		ct = max(err(i)(1:per));
		confix=[ci, ci, ct, ct];
		confiy=[0, 1.1*max(derr), 1.1*max(derr), 0];
		
		% plot error
		figure(1);
		hold off;
		mitt = [1 1]*mitte;
		plot(xerr,derr,mitt,[0, 1.1*max(derr)],confix,confiy);
		legend("distribucion de error",["mediana de error ",num2str(mitte)],["intervallo de confidencia de ",num2str(pro)," % de equipo desde ",num2str(ci)," hasta ",num2str(ct)]);
		title(["distribucion de errores de aproximacion de duracion para ",lab]);
		xlabel("dias");
		hold off;
		
		% plot de datos
		n = find(ismember(Labs,lab)) + 1;
		figure(n);
		hold off;
		plot(equi,frec,equi,dura,x,y,equi,dura+ct);
		hold on;
		%plot(equi,dura2,'g');
		%plot(D.equipoRL(proc),y,'r.');
		%plot(equical,calca,'b');
		hold off;
		title(lab);
		lege={"terminaciones/dia predicatado";"duracion en rec. mas lab. en dias de semana predicatado";"medianas de duracion de muestras de datos";["barrera de ",num2str(pro)," %"]};
		legend(lege);
		xlabel("equipos en laboratorio y recepcion");
		
		% numeros de mostrar
		zu = zeit - ct;
		e = ((norm*zu) - coeff(2))/coeff(1);
		f = e/zu;
		d = e/f;
		if (e > 0)
			if (e <= bis)
				hold on;
				xl=[e e];
				yl=[0 max([max(dura+ct),max(frec),max(y)])];
				plot(xl, yl,'5');
				lege{1+length(lege)} = ["Numero de equipos en lab. mas rec. perseguido para terminar ",num2str(pro)," % en ",num2str(zeit)," dias de semana"];
				legend(lege);
				hold off;
			endif
			printf(["\n ---- para terminar ",num2str(pro)," %% de procesos entre ",num2str(zeit)," dias de semana ----\n"]);
			printf(["Numero de equipos en lab. mas rec. perseguido:	",num2str(e),"\n"]);
			printf(["Numero de recepcionadas/dia perseguido:		",num2str(f),"\n"]);
			printf(["La frequencia de terminaciones por dia converge hacia:	",num2str(f),"\n"]);
			printf(["La mediana de duracion de proceso en recepcion mas laboratorio previsto:	",num2str(d)," dias\n\n"]);
		else
			printf(["\nSegun los datos el laboratorio no puede cumblir con los solicitudes.\n"]);
		endif
		input("presione entre ...",'s');
		
	endfor
	
endfunction