function changeCity(handles,stWeather)
% function to do something usefull (fill out)
% Usage [out_param] = updateWeather(in_param)
% Input Parameter:
%	 in_param: 		 Explain the parameter, default values, and units
% Output Parameter:
%	 out_param: 	 Explain the parameter, default values, and units
%------------------------------------------------------------------------ 
% Example: Provide example here if applicable (one or two lines) 

% Author: S.Volke (c) IHA @ Jade Hochschule applied licence see EOF 
% Version History:
% Ver. 0.01 initial create (empty) 10-Apr-2014  Initials (eg. JB)

%------------Your function implementation here--------------------------- 



prompt = {'Bitte eine Stadt eingeben:'};
dlg_title = 'Stadt Wählen';
num_lines = 1;
answer = inputdlg(prompt,dlg_title,num_lines);

if isempty(answer); return; end

bError = stWeather.init(0,answer{1});

while bError == 1
    prompt = {'Die gewünschte Stadt konnte nicht gefunden werden. Bitte nochmal:'};
    dlg_title = 'Stadt Wählen';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    if isempty(answer); return; end
    bError = stWeather.init(0,answer{1});
end

updateWeather(handles,stWeather,0);




%--------------------Licence ---------------------------------------------
% Copyright (c) <2014> S.Volke
% Institute for Hearing Technology and Audiology
% Jade University of Applied Sciences 
% Permission is hereby granted, free of charge, to any person obtaining 
% a copy of this software and associated documentation files 
% (the "Software"), to deal in the Software without restriction, including 
% without limitation the rights to use, copy, modify, merge, publish, 
% distribute, sublicense, and/or sell copies of the Software, and to
% permit persons to whom the Software is furnished to do so, subject
% to the following conditions:
% The above copyright notice and this permission notice shall be included 
% in all copies or substantial portions of the Software.
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
% IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
% CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
% TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
% SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.