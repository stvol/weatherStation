function stWSReturn = weatherStationModel(szCity)
% function to do something usefull (fill out)
% Usage [out_param] = weatherStationModel(in_param)
% Input Parameter:
%	 in_param: 		 Explain the parameter, default values, and units
% Output Parameter:
%	 out_param: 	 Explain the parameter, default values, and units
%------------------------------------------------------------------------ 
% Example: Provide example here if applicable (one or two lines) 

% Author: S.Volke (c) IHA @ Jade Hochschule applied licence see EOF 
% Version History:
% Ver. 0.01 initial create (empty) 09-Apr-2014  Initials (eg. JB)

%------------Your function implementation here--------------------------- 

% return data struct
stWSReturn = struct();
stWSReturn.getCountry = @getCountry;
stWSReturn.getMeanTempForDay = @getMeanTempForDay;
stWSReturn.getMaxTempForDay = @getMaxTempForDay;
stWSReturn.getNightTempForDay = @getNightTempForDay;
stWSReturn.getHumidityForDay = @getHumidityForDay;
stWSReturn.getCloudsNameForDay = @getCloudsNameForDay;
stWSReturn.getCity = @getCity;
stWSReturn.getDateForDay = @getDateForDay;
stWSReturn.getNameForDay = @getNameForDay;
stWSReturn.getWeatherNameForDay = @getWeatherNameForDay;

% member variables
m_szCity = '';
m_stWSData = struct();
m_bIsInit = 0;


% init weatherStationModel
init(szCity);


%-------------------------------------------------------------------------%
%--------------------------- PRIVATE FUNCTIONS ---------------------------%
%-------------------------------------------------------------------------%

function init(szCityName)
    m_szCity = szCityName;
    if ~exist([m_szCity,'.xml'],'file')
    szString = ['http://api.openweathermap.org/data/2.5/forecast/daily?q=',...
        m_szCity,'&mode=xml&units=metric&cnt=5'];
    [szFileString,bStatus] = urlwrite(szString,[m_szCity,'.xml']);
    else
       szFileString = [m_szCity,'.xml'];
       bStatus = 1;
    end
    
    if bStatus == 0
        stWSReturn.error = true;
    else
        xml = xmlread(szFileString);
        m_stWSData = parse_xml(xml);
        m_bIsInit = 1;
    end
end



%-------------------------------------------------------------------------%
%--------------------------- PUBLIC FUNCTIONS ---------------------------%
%-------------------------------------------------------------------------%

    function szCity = getCity()
        if ~m_bIsInit; init(); end
        szCity = m_szCity;
    end
    
    function szCountry =  getCountry()
        if ~m_bIsInit; init(); end
        szCountry =  m_stWSData.children{1}.children{1}.children{3}.children;
    end

%-------------------------------------------------------------------------%

    function szDayTemp = getMeanTempForDay(iDayNum)
        szDayTemp = m_stWSData.children{1}.children{5}.children{iDayNum}.children{5}.attributes.day;
        szDayTemp = strrep(szDayTemp,'.',',');
    end

%-------------------------------------------------------------------------%

    function szMaxTemp = getMaxTempForDay(iDayNum)
        szMaxTemp = m_stWSData.children{1}.children{5}.children{iDayNum}.children{5}.attributes.max;
    end

%-------------------------------------------------------------------------%

    function szNightTemp = getNightTempForDay(iDayNum)
       szNightTemp = m_stWSData.children{1}.children{5}.children{iDayNum}.children{5}.attributes.night; 
       szNightTemp = strrep(szNightTemp,'.',',');
    end

%-------------------------------------------------------------------------%

    function szHumidity = getHumidityForDay(iDayNum) 
        szHumidity = m_stWSData.children{1}.children{5}.children{iDayNum}.children{7}.attributes.value; 
    end

%-------------------------------------------------------------------------%

    function szCloudsName = getCloudsNameForDay(iDayNum)
        szCloudsName = m_stWSData.children{1}.children{5}.children{iDayNum}.children{1}.attributes.number;
        %%szCloudsName = regexprep(szCloudsName,'[^\w'']','');
    end

    function szDate = getDateForDay(iDayNum)
        szDate = m_stWSData.children{1}.children{5}.children{iDayNum}.attributes.day;
        szDate = datestr(szDate,'dd.mm','local');
    end

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

    function szWeatherName = getWeatherNameForDay(iDayNum)
        szWeatherVar = m_stWSData.children{1}.children{5}.children{iDayNum}.children{1}.attributes.var;
        
        switch szWeatherVar
            case '01d'
                szWeatherName = 'klar';
            case '02d'
                szWeatherName = 'leicht bewölkt';
            case '03d'
                szWeatherName = 'aufgelockert';
            case '04d'
                szWeatherName = 'bedeckt'
            case '09d'
                szWeatherName = 'leichte Schauer';
            case '10d'
                szWeatherName = 'Regen';
            case '11d'
                szWeatherName = 'Sturmregen';
            case '13d'
                szWeatherName = 'Schnee';
            case '50d'
                szWeatherName = 'Hochnebel';
        end
        
    end
%-------------------------------------------------------------------------%

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