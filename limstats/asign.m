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

function [x lege len] = asign(D,xa)

l=length(xa);

%Offset
of=0;
	
for i = 1:l
	switch (xa(i))
		case "t"
			x{i-of,1} = D.duraTrab/86400;
			lege{i-of,1}="duracion de trabajo en dias";
		case "l"
			x{i-of,1} = D.duraLab/86400;
			lege{i-of,1}="duracion en laboratorio en dias";
		case "r"
			x{i-of,1} = D.duraRec/86400;
			lege{i-of,1}="duracion en recepcion en dias";
		case "d"
			x{i-of,1} = D.duraDes/86400;
			lege{i-of,1}="duracion en Despacho en dias";
		case "m"
			x{i-of,1} = D.duraMas/86400;
			lege{i-of,1}="duracion en rec. mas lab. en dias";
		case "o"
			x{i-of,1} = D.dura/86400;
			lege{i-of,1}="duracion entera en dias";
		case "c"
			try
				x{i-of,1} = D.duraTeorica/86400;
				lege{i-of,1}="duracion teorica en dias";
			catch
				error("Duracion Teorica aun no calculado. Ejecute opcion t.");
			end_try_catch
		case "e"
			try
				x{i-of,1} = D.equipoEnLab;
				lege{i-of,1}="mediana numero de equipo en lab.";
			catch
				error("Numero de equipo en lab. aun no calculado. Ejecute opcion t.");
			end_try_catch
		case "p"
			try
				x{i-of,1} = D.equipoRL;
				lege{i-of,1}="mediana numero de equipo en lab. y rec.";
			catch
				error("Numero de equipo en lab. y rec. aun no calculado. Ejecute opcion t.");
			end_try_catch
		otherwise
			++of;
	endswitch
endfor
try
	len = length(lege(:,1));
catch
	len = 0;
end_try_catch

endfunction