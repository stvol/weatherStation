function changeCity(~,~,handles,stWeather)
% controller function to change weather station
% this file is part of weather Station (see README.md)
% to start weather station run WS_START.m
% Usage changeCity(handles,stWeather)
% Input Parameter:
%	 handles: 		 GUI handles, generated by WeatherStationGUI.m
%    stWeather:      data handle to weatherStationModel.m
%------------------------------------------------------------------------  

% Author: S.Volke (c) IHA @ Jade Hochschule applied licence see EOF 

%------------Your function implementation here--------------------------- 


% first promt for city request
prompt = {'Bitte eine Stadt eingeben:'};
dlg_title = 'Stadt W�hlen';
num_lines = 1;
answer = inputdlg(prompt,dlg_title,num_lines);

% return if cancel pressed
if isempty(answer); return; end

% try to change city
bError = stWeather.changeStation(answer{1});

% if city was not found try again
while bError == 1
    prompt = {'Die gew�nschte Stadt konnte nicht gefunden werden. Bitte nochmal:'};
    dlg_title = 'Stadt w�hlen';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    if isempty(answer); return; end
    bError = stWeather.changeStation(answer{1});
end

% update data in GUI
updateGUI(handles,stWeather);

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