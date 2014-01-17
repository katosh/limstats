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

function desarrollo(D,dias,lab,Labs,in,out,rad)
	
	Status = "preparacion ..."

	if !exist("rad")
		rad=[];
	endif
	
	ind = find(!D.error);
	
	if isempty(in)
		[v imin]=min(D.in(ind));
		in = D.Fin(ind)(imin);
	endif
	if isempty(out)
		[v imax]=max(D.out(ind));
		out = D.Fout(ind)(imax);
	endif

	
	[dias.F w f] = unique(dias.F,'first');
	[dias.in rei] = sort(dias.in(w));
	dias.out = dias.out(w)(rei);
	dias.ocu = dias.ocu(:,w(rei));
	dias.F = dias.F(rei);

	[com tom] = confinout(in,out);
	
	c = min(find(dias.in > com));
	t = min(find(dias.out > tom));

	dias.F=dias.F(c:t);
	dias.in=dias.in(c:t);
	dias.out=dias.out(c:t);
	dias.ocu=dias.ocu(:,c:t);
	l=length(dias.in);
	
	x=1:l;
	
	[rec term dura ocu] = desLab(D,dias,lab,Labs);
	
	rec=approxa(rec,x,rad);
	term=approxa(term,x,rad);
	dura=approxa(dura,x,rad);
	ocu=approxa(ocu,x,rad);

	% factura por ocupacion
	temp=max(ocu)/max([max(rec) max(term) max(dura)]);
	of=ceil(temp);
	if of > 0 ocu=ocu/of; endif
		
	if isempty(lab)
		n=1;
		lab="Desarrollo";
	else
		n = find(ismember(Labs,lab)) + 1;
	endif
	
	figure(n);
	xap = 1:length(rec);
	plot(xap,rec,xap,term,xap,dura,xap,ocu);
	legend("recepciones","terminaciones","duracion en rec. mas lab.",["numero de equipos en laboratorio y recepcion durante proceso en ",num2str(of)])
	title(lab);
	
	numero = 50;
	xtick=floor(linspace(0,500,numero));
	pin = floor(linspace(1,l,numero));
	set(gca(),'xtick',xtick); % set tick pos. manually 
	xticklabel=dias.F(pin);
	set(gca(),'xticklabel',"");
	
	## get position of current xtick labels
	h = get(gca,'xlabel');
	xlabelstring = get(h,'string');
	xlabelposition = get(h,'position');

	## construct position of new xtick labels
	yposition = xlabelposition(2);
	yposition = repmat(yposition,length(xtick),1);

	## disable current xtick labels
	% set(gca,'xtick',[]);

	## set up new xtick labels and rotate
	hnew = text(xtick, yposition, xticklabel);
	set(hnew,'rotation',90,'horizontalalignment','right');
	
endfunction