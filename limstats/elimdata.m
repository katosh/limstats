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

function [data index] = elimdata(opt,D,dias,in,out,trab,lab,Labs,err)

	try
		test=!err;
	catch
		err=0;
	end_try_catch
	
	if isempty(in)
		in = min(opt);
	elseif !isnumeric(in)
		in = confech(in);
	endif
	if isempty(out)
		out = max(opt);
	elseif !isnumeric(out)
		out = confech(out);
	endif
	
	ind = (in <= opt) & (opt <= out);
	
	if ismember(lab,Labs)
		ind = ind & ismember(D.Lab,lab)';
	endif
	if trab
		ind = ind & ismember(floor(opt/86400),floor(dias.in/86400));
	endif
	if err
		ind = ind & !D.error;
	endif
	
	index = find(ind);
	data = opt(index);
	
endfunction