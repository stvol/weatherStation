function updateGUI(handles,stWeather)
% function to set weather data to GUI generated with WeatherStationGUI.m
% this file is part of weather Station (see README.md)
% to start weather station run WS_START.m
% Usage updateGUI(handles,stWeater)
% 
% Input Parameter:
%	 handles: 		 GUI handles, generated by WeatherStationGUI.m
%    stWeather:      handle to data stored in weatherStationModel.m
%------------------------------------------------------------------------ 

% Author: S.Volke (c) IHA @ Jade Hochschule applied licence see EOF 

%------------Your function implementation here--------------------------- 

set(handles.h_CityName,'String',['Wetteraussichten f�r: ',char(stWeather.getCity()),',',char(stWeather.getCountry())]);
set(handles.h_updateTime,'String',sprintf(['Wetterdaten vom:',char(10),datestr(stWeather.getUpdateTime(),'dd.mm.yyyy HH:MM:SS')]));

for ii = 1:5
   set(handles.h_dayDate(ii),'String',[char(stWeather.getDateForDay(ii))]);
   set(handles.h_dayDateName(ii),'String',[char(stWeather.getNameForDay(ii))]);
   set(handles.h_dayTemp(ii),'String',[char(stWeather.getMeanTempForDay(ii)),' �C']);
   set(handles.h_nightTemp(ii),'String',[char(stWeather.getNightTempForDay(ii)),' �C']);
   
   imagename = [stWeather.getCloudsNameForDay(ii),'d.jpg'];
   image2display = imread(imagename);
   handles.h_CloudsPic(ii);
   axes(handles.h_CloudsPic(ii));
   image([0 1],[0 1],image2display);
   axis off;
   axis normal;
   whitebg('white');
   
   set(handles.h_CloudName(ii),'String',[char(stWeather.getWeatherNameForDay(ii))]);
   set(handles.h_WindData(ii),'String',[char(stWeather.getWindDataForDay(ii))]);
   set(handles.h_HumidityData(ii),'String',[char(stWeather.getHumidityDataForDay(ii)),'%']);
   set(handles.h_PressureData(ii),'String',char(stWeather.getPressureDataForDay(ii)));
end

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