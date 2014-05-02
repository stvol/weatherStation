function updateGUI(handles,stWeather)
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

set(handles.h_CityName,'String',['Wetteraussichten für: ',char(stWeather.getCity()),',',char(stWeather.getCountry())]);

for ii = 1:5
   set(handles.h_dayDate(ii),'String',[char(stWeather.getDateForDay(ii))]);
   set(handles.h_dayDateName(ii),'String',[char(stWeather.getNameForDay(ii))]);
   set(handles.h_dayTemp(ii),'String',[char(stWeather.getMeanTempForDay(ii)),' °C']);
   set(handles.h_nightTemp(ii),'String',[char(stWeather.getNightTempForDay(ii)),' °C']);
   
   imagename = [stWeather.getCloudsNameForDay(ii),'d.jpg'];
   image2display = imread(imagename);
   handles.h_CloudsPic(ii)
   axes(handles.h_CloudsPic(ii));
   image([0 1],[0 1],image2display);
   axis off;
   axis normal;
   whitebg('white')
   
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