% This file is part of limstats written by Dominik Otto.written by Dominik Otto.

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

if !exist("dias") 
	[D dias Labs] = loadAll; 
else
	Status = "Ya hay datos cargado."
endif

try
while(1)

printf("\n ---- Bienvenido, cual informaciones quiere? ----\n\n");
printf(" n - estatisticas en numeros\n");
printf(" i - informaciones sobre una muestra o eliminarlo\n");
printf("\n m - graficos sobre muestras\n");
printf(" r - graficos sobre un periodo de tiempo\n");
printf(" d - graficos sobre tiempos de un dia\n");
printf(" p - graficos de predicciones\n");
printf("\n c - calcular capacidad teorica\n");
printf("	... es obligario para predicciones y se muestran en estatisticas en numeros (opcion n)\n");
printf(" o - calcular ocupaciones de laboratorios en dias\n");
printf("	... que se muestran en graficos sobre un rato (opcion r)\n");
printf("\n g - carga datos nuevamente\n");
printf(" x - monstra y elmina muestras extremas\n");
printf(" e - monstra y elmina muestras con errores\n");
printf("\n q - quitar \n\n");
opt = input(" Letra: ",'s');

switch(opt)
case "n"
	printf("\nElije laboratorio.");
	printf("\nDeje blanco por estatistica para cada uno.");
	printf("\nEntre \"lista\" por un lista de laboratorios.");
	printf("\nEntre \"q\" para quitarse a menu.\n");
	lab = enterlab(Labs);
	
	while !isempty(lab) && !ismember(lab,Labs)
	
		if isequal(lab,"q")
			break;
		elseif isequal(lab,"lista");
			Labs
		else
			printf([lab," no encontrada.\n"]);
		endif
		
		lab = enterlab(Labs);
	endwhile
	if isequal(lab,"q")
		break;
	endif
	
	printf("\nEscribe en eso formato: dd/mm/yyyy\n");
	printf("Si no entras nada se busca por fechas entre los muestras.\n");
	[in out] = enterDate;
	
	stats(D,dias,lab,Labs,in,out);

case "i"
	n=input("Nombre de Muestra: ",'s');
	i=datMuestra(D,n);

	if !isempty(i)
		printf("\nQuiere eliminarlo?\n");
		printf("si / no\n");
		opt=input("",'s');
		
		%try
		if isequal(opt,"si")

			for [ val, nombre ] = D
				%disp(nombre)
				eval(["D.",nombre,"(i)=[];"],"error(lasterr());");
				%val(i)=[];
			endfor
			
			printf("\nRecalcule ocupacion y capacitad teorica para resultos mejor.\n");
			input("presione entre ...",'s');

		endif
		%end_try_catch
	endif
	
case "m"
	printf("\nElije laboratorio.");
	printf("\nDeje blanco por estatistica sobre todos.");
	printf("\nEntre \"lista\" por un lista de laboratorios.");
	printf("\nEntre \"q\" para quitarse a menu.\n");
	lab = enterlab(Labs);
	
	while !isempty(lab) && !ismember(lab,Labs)
	
		if isequal(lab,"q")
			break;
		elseif isequal(lab,"lista");
			Labs
		else
			printf([lab," no encontrada.\n"]);
		endif
		
		lab = enterlab(Labs);
	endwhile
	if isequal(lab,"q")
		break;
	endif
	
	printf("\nElija fechas en este formato: dd/mm/yyyy\n");
	printf("Si no entras nada se busca por fechas entre los muestras.\n");
	[in out] = enterDate;
	
	printf("\nPropiedad por el eje x.\n");
	printf("t - duracion de trabajo\n");
	printf("l - duracion en laboratorio\n");
	printf("r - duracion en recepcion\n");
	printf("m - duracion en rec. mas lab.\n");
	printf("d - duracion en despacho\n");
	printf("o - duracion total\n");
	printf("c - duracion teorica\n");
	printf("e - equipo en lab. durante proceso\n");
	printf("p - equipo en lab. y rec. durante proceso\n");
	printf("q - quitarse a menu\n");
	do
		printf("Selecte a menus uno proporidad.\n");
		xa = input("Letra: ",'s');
	until !isempty(xa)
	
	
	if xa(1) == "q"
		break;
	endif
	
	printf("\nPropiedades por el eje y. \n");
	printf("t - duracion de trabajo \n");
	printf("l - duracion en laboratorio \n");
	printf("r - duracion en recepcion \n");
	printf("m - duracion en rec. mas lab.\n");
	printf("d - duracion en despacho\n");
	printf("o - duracion total \n");
	printf("c - duracion teorica \n");
	printf("e - equipo en lab. durante proceso\n");
	printf("p - equipo en lab. y rec. durante proceso\n");
	printf("q - quitarse a menue\n");
	printf("Puede entra mas de una letra.\n");
	%ya = input("Letras: ",'s');
	do
		printf("Selecte a menus uno proporidad.\n");
		ya = input("Letras: ",'s');
	until !isempty(ya)
	
	if ya(1) == "q"
		break;
	endif
	
	con = false;
	elim=zeros(4,1);
	if length(ya) == 1
		printf("\nQuiere análisis de convergencia?\n");
		printf("si/no\n");
		cona=input("Respuesta: ",'s');
		try
			con = (cona(1)=="s");
		end_try_catch
		if con
			printf("\nPara un regresion mejor se elimina la persentaje entrada de esos datos:\n");
			printf("Desde el principio de eje x: ");
			elim(1)=enterPer;
			printf("Desde el final de eje x: ");
			elim(2)=enterPer;
			printf("Desde el principio de eje y: ");
			elim(3)=enterPer;
			printf("Desde el final de eje y: ");
			elim(4)=enterPer;
		endif
	endif
	
	plottM(D,dias,xa,ya,lab,Labs,con,in,out,elim);

case "r"
	printf("\nElija rato en este formato: dd/mm/yyyy\n");
	printf("Si no entras nada se lo busca entre los muestras.\n");
	[in out] = enterDate;
	
	printf("\nElije laboratorio.");
	printf("\nDeje blanco por estatistica sobre todos.");
	printf("\nEntre \"lista\" por un lista de laboratorios.");
	printf("\nEntre \"q\" para quitarse a menu.\n");
	lab = enterlab(Labs);
	
	while !isempty(lab) && !ismember(lab,Labs)
	
		if isequal(lab,"q")
			break;
		elseif isequal(lab,"lista");
			Labs
		else
			printf([lab," no encontrada.\n"]);
		endif
		
		lab = enterlab(Labs);
	endwhile
	if isequal(lab,"q")
		break;
	endif
	
	if isempty(lab)
		printf("Laboratorios en muestras.csv:\n");
		Labs
		input("presione entre ...",'s');
	endif
	
	printf("\nPara un grafico liso y legible.\n");
	printf("Es una opcion avanzada, deja en blanco por un numero automatico.\n");
	rad = input("Medianas sobre este numero de dias: ");
	
	desarrollo(D,dias,lab,Labs,in,out,rad);
case "d"
	printf("\n Elije dato de estatisticas. Mas de uno posible.\n");
	printf(" r - recepcionadas\n");
	printf(" i - ingresadas a proceso\n");
	printf(" o - ocupacion\n");
	printf(" t - terminados\n");
	printf(" p - predespachadas\n");
	printf(" d - despachadas\n");
	printf(" q - quitarse a menu\n");
	do
		printf(" Selecte a menus uno proporidad.\n");
		opt = input(" Letras: ",'s');
	until !isempty(opt)
	
	
	if opt(1) == "q"
		break;
	endif
	
	printf("\nElije laboratorio.");
	printf("\nDeje blanco por estatistica sobre todos.");
	printf("\nEntre \"lista\" por un lista de laboratorios.");
	printf("\nEntre \"q\" para quitarse a menu.\n");
	lab = enterlab(Labs);
	
	while !isempty(lab) && !ismember(lab,Labs)
	
		if isequal(lab,"q")
			break;
		elseif isequal(lab,"lista");
			Labs
		else
			printf([lab," no encontrada.\n"]);
		endif
		
		lab = enterlab(Labs);
	endwhile
	if isequal(lab,"q")
		break;
	endif
	
	printf("\nElije cliente.");
	printf("\nDeje blanco por estatistica sobre todos.");
	printf("\nEntre \"lista\" por un lista de clientes.");
	printf("\nEntre \"q\" para quitarse a menu.\n");
	client = input("Cliente: ",'s');
	if ismember(toupper(client),D.Cliente) && !ismember(client,D.Cliente)
		client=toupper(client);
	endif
	
	% muestras para mostrar
	pos = ones(length(D.in),1);
	
	while !isempty(client) && !ismember(client,D.Cliente)
	
		if isequal(client,"q")
			break;
		elseif isequal(client,"lista");
			try if !isempty(lab)
				pos = pos & ismember(D.Lab,lab);
			endif
			end_try_catch
			clientes = sort(unique(D.Cliente(find(pos))))
		else
			printf([client," no encontrada.\n"]);
		endif
		
		client = input("Cliente: ",'s');
		if ismember(toupper(client),D.Cliente) && !ismember(client,D.Cliente)
			client=toupper(client);
		endif
	endwhile
	
	if isequal(client,"q")
		break;
	endif
	
	printf("\nElije tipo de muestra.");
	printf("\nDeje blanco por estatistica sobre todos.");
	printf("\nEntre \"lista\" por un lista de clientes.");
	printf("\nEntre \"q\" para quitarse a menu.\n");
	tipo = input("Tipo: ",'s');
	if ismember(toupper(tipo),D.tipo) && !ismember(tipo,D.tipo)
		tipo=toupper(tipo);
	endif
	
	% muestras para mostrar
	pos = ones(length(D.in),1);
	
	while !isempty(tipo) && !ismember(tipo,D.tipo)
	
		if isequal(tipo,"q")
			break;
		elseif isequal(tipo,"lista");
			try if !isempty(lab)
				pos = pos & ismember(D.Lab,lab);
			endif
			end_try_catch
			try if !isempty(client)
				pos = pos & ismember(D.Cliente,client);
			endif
			end_try_catch
			tipos = sort(unique(D.tipo(find(pos))))
		else
			printf([tipo," no encontrada.\n"]);
		endif
		
		tipo = input("Tipo: ",'s');
		if ismember(toupper(tipo),D.tipo) && !ismember(tipo,D.tipo)
			tipo=toupper(tipo);
		endif
	endwhile
	
	if isequal(tipo,"q")
		break;
	endif
	
	printf("\nElija rato de estatisticas en este formato: dd/mm/yyyy\n");
	printf("Si no entras nada se busca rato mas largo entre los muestras.\n");
	[in out] = enterDate;
	
	printf("Sobre ...\n");
	printf("1 - ... solo dias de trabajo\n");
	printf("0 - ... todos los dias\n");
	
	fin = 0;
	do
		try
			trab = input("Numero: ");
			test=!trab;
			fin=true;
		catch
			printf("No valida.\n");
		end_try_catch
	until fin
	
	diastat(D,dias,opt,lab,tipo,client,Labs,in,out,trab);

case "p"
	
	if isfield(D,"equipoRL")
		printf("\nElije laboratorio.");
		printf("\nEntre \"lista\" por un lista de laboratorios.");
		printf("\nEntre \"q\" para quitarse a menu.\n");
		lab = enterlab(Labs);
		
		while !ismember(lab,Labs)
		
			if isequal(lab,"q")
				break;
			elseif isequal(lab,"lista");
				Labs
			elseif isempty(lab)
				printf("Por favor elija un laboratorio.\n");
			else
				printf([lab," no encontrada.\n"]);
			endif
			
			lab = enterlab(Labs);
		endwhile
		if isequal(lab,"q")
			break;
		endif
		
		printf("\nElija rato de datos que deben ocupado para prediccion.");
		printf("Escribe en eso formato: dd/mm/yyyy\n");
		printf("Si no entras nada se busca por fechas entre los muestras.\n");
		[in out] = enterDate;
		
		printf("\nPrediccion hasta cual numero de eqipos en recepcion y laboratorio?\n");
		printf("Deje en blanco para buscar el numero maximo de equipos que hubo en datos.\n");
		bis=input("Numero de equipo: ");
		
		printf("\nEn cuanto tiempo los procesos deben estar terminado?\n");
		zeit=input("Numero de dias de semana: ");
		
		printf("\nCuento persentaje deben estar terminado entre este rato?\n");
		pro=input("Numero: ");
		
		predict(D,dias,lab,Labs,in,out,bis,pro,zeit);
	else
		printf("\nCalcule capacidad teorica (opcion t) primero.\n");
		input("presione entre ...",'s');
	endif
	
case "o"
	dias = ocupas(D,dias,Labs);
case "c"
	D=teorica(D,dias,Labs);
case "x"
	printf("\nExtremas de ...\n");
	printf("t - duracion de trabajo\n");
	printf("l - duracion en laboratorio\n");
	printf("r - duracion en recepcion\n");
	printf("m - duracion en rec. mas lab.\n");
	printf("d - duracion en despacho\n");
	printf("o - duracion total\n");
	printf("e - equipo en lab. durante\n");
	printf("p - equipo en lab. y rec. durante proceso\n");
	printf("q - quitarse a menu\n");
	do
		printf("Selecte una propiedad.\n");
		xa = input("Letra: ",'s');
		[x lege len] = asign(D,xa);
	until ((xa(1)=="q") || (len==1))
	
	if xa == "q"
		break;
	endif
	
	printf("\nElije laboratorio si quiere filtrar por uno.");
	printf("\nDeje en blanco para ver muestras de todos.");
	printf("\nEntre \"lista\" por un lista de laboratorios.");
	printf("\nEntre \"q\" para quitarse a menu.\n");
	lab = enterlab(Labs);
	
	while !isempty(lab) && !ismember(lab,Labs)
	
		if isequal(lab,"q")
			break;
		elseif isequal(lab,"lista");
			Labs
		else
			printf([lab," no encontrada.\n"]);
		endif
		
		lab = enterlab(Labs);
	endwhile
	if isequal(lab,"q")
		break;
	endif
	
	printf("\nElija fechas entre cual los muestras deben terminar en este formato: dd/mm/yyyy\n");
	printf("Si no entras nada se busca por fechas entre los muestras.\n");
	[in out] = enterDate;
	try
		[in out] = confinout(in,out);
	end_try_catch
	
	l=length(x{1,1});
	pos = ones(1,l);
	
	if !isempty(lab)
		pos = pos & ismember(D.Lab,lab)';
	endif
	
	if !isempty(in) && !isempty(out)
		pos = pos & (D.eP>=in) & (D.eP<=out);
	endif
	
	ind=find(pos);
	x{1,1} = x{1,1}(ind);
	l=length(x{1,1});
	
	printf(["\nHay ",num2str(l),", cuando quiere ver?\n"]);
	n=input("Numero: ");
	if (n > l) n=l;	endif
	if isempty(n) || (n==0) 
		n = 10; 
	endif
	
	[temp i]=sort(-x{1,1});
	printf(["\nMayores de ",lege{1},":\n"]);
	for j = 1:n
		printf(["(",num2str(j),") ",D.muestra(ind)(i){j}," : ",num2str(-temp(j)),"\n"]);
	endfor
	
	printf("\nCuanto quiere eliminar?\n");
	cona=input("Respuesta: ");

	if cona > n
		cona = n;
	endif
	
	if !isempty(cona)
		Status="eleminando ..."
		for [ val, nombre ] = D
			%["D.",nombre,"(find(pos)(i(1:cona)))=[];"]
			eval(["D.",nombre,"(find(pos)(i(1:cona)))=[];"],"error(lasterr());");
			%val(i(1:cona+1))=[];
		endfor
		
		printf("\n Recalcule ocupacion y capacitad teorica para resultos mejor.\n");
		input("presione entre ...",'s');

	endif
	
case "g"
	clear;
	[D dias Labs] = loadAll;
case "e"
	er=sum(D.error);
	ind = find(D.error);
	
	printf(["\nHay ",num2str(er),", cuando quiere ver?\n"]);
	n=input("Numero: ");
	if isempty(n) || (n > er)
		n = er;
	endif
	printf("\no - ordenado | a - azar\n");
	op = input("Letra: ",'s');
	if op == "a"
		D.muestra(ind(randperm(n)))
	else
		[temp i] = sort(D.muestra(ind));
		D.muestra(ind(i))(1:n)
	endif
	
	printf("Quiere eliminarlos?\n");
	printf("si / no\n");
	opt=input("",'s');
	
	try
	if isequal(opt,"si")
		Status="eleminando ..."
		for [ val, nombre ] = D
			eval(["D.",nombre,"(ind(i)(1:n))=[];"],"error(lasterr());");
		endfor
		
		printf("\n Recalcule ocupacion y capacitad teorica para resultos mejor.\n");
		input(" presione enter ...",'s');

	endif
	end_try_catch
case "q"
	quit
otherwise
	printf("\n Eso no es una opcion. \n \n");
	input("presione entre ...",'s');
endswitch
endwhile

% despues break
run main.m

catch
	disp("--- ERROR ---");
	disp(lasterr);
	disp("\nSi tiene preguntas o comentarios o necesita ayuda, por favor escribe me a dominik.otto@gmail.com");
	input("presione entre ...",'s');
	run main.m
end_try_catch