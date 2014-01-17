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

function [D dias Labs] = loadAll

	% load todos datos
	clear;
	Status="carga de datos ..."
	
	Status = "Paso 1 de 4:"
	Status="cargando muestras ..."
	[D.IDMUESTRA, D.muestra, D.Lab, D.tipo, D.idTipo, D.Rango, D.Fin,D.Hin, D.Fp,D.Hp, D.Ft,D.Ht, D.Fpre,D.Hpre, D.Fout,D.Hout, D.Cliente, D.direccion,  D.despaConfa, D.despaConi]=textread(
		["../Datos/muestras.csv"],
		"%n %s %s %s %n %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s",
		"delimiter",";","headerlines",1);
		
	Status="Paso 2 de 4:"
	D=complet(D);
	
	Status="Paso 3 de 4:"
	Status="cargando dias ..."
	dias = loadDias;
	
	Status="Paso 4 de 4:"
	Status="calculacion de tiempos de trabajo ..."
		%disp("Si esa nesecita tanto rato tratar librar algo memoria principal a cerrar programas.");
		%D.duraTrab = duraTrabajo(dias,D.sP,D.eP);
	% partir para ocupar menos memoria principal:
	l=length(D.sP);
	D.duraTrab = zeros(1,l);
	D.duraTrabM = zeros(1,l);
	partes = floor(l/3000);
	ps = ceil(linspace(1,l,partes+1));
	for i=1:partes
		D.duraTrab(ps(i):ps(i+1)) = duraTrabajo(dias,D.sP(ps(i):ps(i+1)),D.eP(ps(i):ps(i+1)));
		D.duraTrabM(ps(i):ps(i+1)) = duraTrabajo(dias,D.in(ps(i):ps(i+1)),D.eP(ps(i):ps(i+1)));
	endfor

	% losta de laboratorios
	Labs=unique(D.Lab);
	dias.ocu = zeros(length(Labs)+1,length(dias.in));
	
	% suficiente dias en tabella de dias?
	ind=find(!D.error);
	if (min(dias.in) > min(D.in(ind))) || (max(dias.out) < max(D.out(ind)))
		printf("\n\n	------ CUIDASDO! ------\n  Hay muy poco ratos en la tabella trabajo.csv por los estatisticas.\n");
		printf(["\n Primero rato inicia en ",strftime('%d-%m-%Y %R',localtime(min(dias.in)))]);
		printf(["\n Ultimo rato termino en ",strftime('%d-%m-%Y %R',localtime(max(dias.out)))]);
		[mi i] = min(D.in);
		[ma a] = max(D.out);
		printf(["\n La muestra ",D.muestra{i}," recebciono en ",strftime('%d-%m-%Y %R',localtime(D.in(i)))]);
		printf(["\n La muestra ",D.muestra{a}," despacho en ",strftime('%d-%m-%Y %R',localtime(D.out(a))),"\n"]);
	endif
	printf(["\n A menos ",num2str(round(1000*sum(D.error)/length(D.in))/10)," %% de datos son malos. \n"]);
	printf("	(faltan fechas o tienen fechas con errores)\n");
	printf(" Todos esos errores estan arreglado con medianas de muestras sin errores para cada laboratorio seperado.\n\n");
endfunction