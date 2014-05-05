function stWSReturn = weatherStationModel(szCity)
% model function for weather data working like a class. It encapsulates 
% methods and member variables to work with.
% Usage stWSReturn = weatherStationModel(szCity)
% 
% Input Parameter:
%	 szCity: 		 name of city to initialize (string)
% Output Parameter:
%	 stWSReturn: 	 handle struct to all public functions
%------------------------------------------------------------------------ 
% Example: Provide example here if applicable (one or two lines) 

% Author: S.Volke (c) IHA @ Jade Hochschule applied licence see EOF 
% Version History:
% Ver. 0.01 initial create (empty) 09-Apr-2014  Initials (eg. JB)

%------------Your function implementation here--------------------------- 

if nargin < 1
    error('you have to specify a city name');
end


% function handle struct to return
stWSReturn = struct();
stWSReturn.getCountry = @getCountry;
stWSReturn.getMeanTempForDay = @getMeanTempForDay;
stWSReturn.getMaxTempForDay = @getMaxTempForDay;
stWSReturn.getNightTempForDay = @getNightTempForDay;
stWSReturn.getCloudsNameForDay = @getCloudsNameForDay;
stWSReturn.getCity = @getCity;
stWSReturn.getDateForDay = @getDateForDay;
stWSReturn.getNameForDay = @getNameForDay;
stWSReturn.getWeatherNameForDay = @getWeatherNameForDay;
stWSReturn.getWindDataForDay = @getWindDataForDay;
stWSReturn.getHumidityDataForDay = @getHumidityDataForDay;
stWSReturn.getPressureDataForDay = @getPressureDataForDay;
stWSReturn.changeStation = @changeStation;
stWSReturn.updateStation = @updateStation;
stWSReturn.getUpdateTime = @getUpdateTime;

% member variables (all private)
m_szCity = szCity;
m_stWSData = struct();
m_bIsInit = 0;
m_szFileString = '';


% init weatherStationModel
init(szCity);


%-------------------------------------------------------------------------%
%--------------------------- PRIVATE FUNCTIONS ---------------------------%
%-------------------------------------------------------------------------%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% function to check wether city exist in API
%
function bError = checkCity(szCityName)

    % string to API
    szString = ['http://api.openweathermap.org/data/2.5/forecast/daily?q=',...
        szCityName,'&mode=xml&units=metric&cnt=5'];
    % try to read read URL
    [szFileContent,st] = urlread(szString,'Charset','ISO-8859-1');

    % if something goes wrong...
    if isempty(szFileContent) ||...
           szFileContent(1) == '{' || strcmpi(szCityName,'test') || st == 0
        bError = 1;
        return;
    end

    bError = 0;
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% init function (constructor)
%
function bError = init(szCityName)

    % city check
    bError = checkCity(szCityName);

    if ~bError
        
        % set member variables
        m_szCity = szCityName;
        m_szFileString = ['data/',m_szCity,'.xml'];
        m_bIsInit = 1;
        
        % set weather data to m_stWSData
        getData();
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% get Data from weather API
%
function bError = getData(bForce)
    
    % check initialization
    if ~m_bIsInit; bError = 1; return; end;
    
    if nargin < 1; bForce = 0;end;

    % check for existing weather data file
    if exist(m_szFileString,'file')

        % check age of File
        stFileInfo = dir(m_szFileString);
        dFileAge = stFileInfo.datenum;
        dNow = now();
        Difference = abs(dFileAge(:) - dNow(:));

        iHours = round(mod(Difference, 1) * 24);
        
        % delete file if older than 5 houres
        if iHours > 5
            delete(m_szFileString);
            bForce = 1;
        end
    else
       bForce = 1;
    end

    % get new data if necessary
    if bForce
        szString = ['http://api.openweathermap.org/data/2.5/forecast/daily?q=',...
            m_szCity,'&mode=xml&units=metric&cnt=5'];
        urlwrite(szString,m_szFileString,'Charset','ISO-8859-1');
    end

    % parse xml 
    xml = xmlread(m_szFileString);
    m_stWSData = parse_xml(xml); 
    bError = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------------------------------------------------------------%
%--------------------------- PUBLIC FUNCTIONS ----------------------------%
%-------------------------------------------------------------------------%

% function to update weather Data
function bError = updateStation()
    
    % check for initialization
    if ~m_bIsInit; bError = 1; return; end;
    
    %force getting new data
    bError = getData(1);
end

%-------------------------------------------------------------------------%

% function to change weather station
function bError = changeStation(szNewCityName)
    
    % check initialization
    if ~m_bIsInit; bError = 1; return; end;
    
    % return if city name did not change
    if strcmpi(szNewCityName,m_szCity)
        bError = 0;
        return;
    end
    % init new city
    bError = init(szNewCityName);
end

%-------------------------------------------------------------------------%
    

%% getter functions for data

function szCity = getCity()
    szCity = m_szCity;
end

%-------------------------------------------------------------------------%
    
function szCountry =  getCountry()
    szCountry =  m_stWSData.children{1}.children{1}.children{3}.children;
end

%-------------------------------------------------------------------------%

function szDayTemp = getMeanTempForDay(iDayNum)
    szDayTemp = m_stWSData.children{1}.children{5}.children{iDayNum}.children{5}.attributes.day;
    
    % replace . by , to fit german localization
    szDayTemp = strrep(szDayTemp,'.',',');
end

%-------------------------------------------------------------------------%

function szNightTemp = getNightTempForDay(iDayNum)
   szNightTemp = m_stWSData.children{1}.children{5}.children{iDayNum}.children{5}.attributes.night; 

   % replace . by , to fit german localization
   szNightTemp = strrep(szNightTemp,'.',',');
end

%-------------------------------------------------------------------------%

function szCloudsName = getCloudsNameForDay(iDayNum)
    szCloudsName = m_stWSData.children{1}.children{5}.children{iDayNum}.children{1}.attributes.number;
end

%-------------------------------------------------------------------------%

function szDate = getDateForDay(iDayNum)
    szDate = m_stWSData.children{1}.children{5}.children{iDayNum}.attributes.day;
    szDate = datestr(szDate,'dd.mm','local');
end

%-------------------------------------------------------------------------%

function szDayName = getNameForDay(iDayNum)
    szDate = m_stWSData.children{1}.children{5}.children{iDayNum}.attributes.day;
    iDate = datenum(szDate);

    [DayNumber, DayName] = weekday(iDate,'long','local');
    today = weekday(now,'long','local');

    switch DayNumber
        case today
            szDayName = 'Heute';
        case today+1
            szDayName = 'Morgen';
        case today-1
            szDayName = 'Gestern';
        otherwise
            szDayName = DayName;
    end



end

%-------------------------------------------------------------------------%

function szWeatherName = getWeatherNameForDay(iDayNum)
    szWeatherVar = m_stWSData.children{1}.children{5}.children{iDayNum}.children{1}.attributes.var;

    switch szWeatherVar
        case {'01d','01n'}
            szWeatherName = 'klar';
        case {'02d','02n'}
            szWeatherName = 'leicht bewölkt';
        case {'03d','03n'}
            szWeatherName = 'aufgelockert';
        case {'04d','04n'}
            szWeatherName = 'bedeckt';
        case {'09d','09n'}
            szWeatherName = 'leichte Schauer';
        case {'10d','10n'}
            szWeatherName = 'Regen';
        case {'11d','11n'}
            szWeatherName = 'Sturmregen';
        case {'13d','13n'}
            szWeatherName = 'Schnee';
        case {'50d','50n'}
            szWeatherName = 'Hochnebel';
    end

end

%-------------------------------------------------------------------------%

function szWindData = getWindDataForDay(iDayNum)
    szWindSpeed = m_stWSData.children{1}.children{5}.children{iDayNum}.children{4}.attributes.mps;
    szWindDirection = m_stWSData.children{1}.children{5}.children{iDayNum}.children{3}.attributes.code;
    szWindDirection = strrep(szWindDirection,'E','O');
    szWindData = [szWindSpeed ,' m/s  ',szWindDirection];
end

%-------------------------------------------------------------------------%

function szHumidityData = getHumidityDataForDay(iDayNum)
    szHumidityData = m_stWSData.children{1}.children{5}.children{iDayNum}.children{7}.attributes.value;
end

%-------------------------------------------------------------------------%

function szPressureData = getPressureDataForDay(iDayNum)
    szPressureData = m_stWSData.children{1}.children{5}.children{iDayNum}.children{6}.attributes.value;
    szPressureUnit = m_stWSData.children{1}.children{5}.children{iDayNum}.children{6}.attributes.unit;
    szPressureData = [szPressureData, ' ', szPressureUnit];
end

%-------------------------------------------------------------------------%


function tsUpdateTime = getUpdateTime()
    stFileInfo = dir(m_szFileString);
    tsUpdateTime = stFileInfo.datenum;
end

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