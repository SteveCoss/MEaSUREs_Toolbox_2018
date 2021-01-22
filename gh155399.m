clear; close all

xstrt = xml2struct('01553990.xml');
rens = xstrt.ns1_colon_timeSeriesResponse.ns1_colon_timeSeries;
tsl = length(rens);
if tsl <=1
    % variable option = mean (stats code = 3)
    if str2double(renamed.ns1_colon_variable.ns1_colon_options.ns1_colon_option.Attributes.optionCode) ...
        ~=3
        error('Not a daily mean!')
    end
    renamed = rens;
    % variableCode = 60 (discharge, ft^3/s), 65 (Gage height, feet)
    if str2double(renamed.ns1_colon_variable.ns1_colon_variableCode.Text) ~=60 && ...
       str2double(renamed.ns1_colon_variable.ns1_colon_variableCode.Text) ~=65
        error('Variable is not discharge or gage height!')
    end
else
    vcode = zeros(tsl,1);
    for tt=1:tsl
        vcode(tt) = str2double(rens{tt}.ns1_colon_variable.ns1_colon_variableCode.Text);
        % variable option = mean (stats code = 3)
        if str2double(rens{tt}.ns1_colon_variable.ns1_colon_options.ns1_colon_option.Attributes.optionCode) ...
        ~=3
            vcode(tt) = 0;
            continue
        end
        % variableCode = 60 (discharge, ft^3/s), 65 (Gage height, feet)
        if vcode(tt) ==60 || vcode(tt) ==65
            break
        end
    end
    ind = find(vcode ==65);
    if isempty(ind)
        ind = find(vcode ==60);
        if isempty(ind)
            error('No daily mean discharge or gage height!')
        %else
            %discharge to stage
        end
    end
    renamed = rens{ind(1)};
end
ll = length(renamed.ns1_colon_values.ns1_colon_value);
arr = zeros(ll,1);
ndate = zeros(ll,1); flags = zeros(ll,1); ice = zeros(ll,1);
for pp=1:ll
    arr(pp) = str2double(renamed.ns1_colon_values.ns1_colon_value{pp}.Text);
    ndate(pp) = datenum(renamed.ns1_colon_values.ns1_colon_value{pp}.Attributes.dateTime, ...
        'yyyy-mm-ddTHH:MM:SS.FFF');
    flags(pp) = 'P' ==renamed.ns1_colon_values.ns1_colon_value{pp}.Attributes.qualifiers(1);
      ice(pp) = 'I' ==renamed.ns1_colon_values.ns1_colon_value{pp}.Attributes.qualifiers(1);
end

vflag = str2double(renamed.ns1_colon_variable.ns1_colon_noDataValue.Text);
arr(arr ==vflag) = NaN;
ft2m = .3048;
h = plot(ndate, arr*ft2m, 'b.'); hold on
set(get(get(h,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off')
ind = find(flags);
plot(ndate(ind), arr(ind)*ft2m, 'ro')
ind = find(ice);
plot(ndate(ind), arr(ind)*ft2m, 'ko'); hold off
datetick ('x', 'yyyy')
set (gca, 'XTick', datenum(2000:2:2020, 1, 1))
set (gca, 'XTickLabel', ...
    [2000;2002;2004;2006;2008;2010;2012;2014;2016;2018;2020])
set(gca, 'FontSize', 18)
xlabel('Year'); ylabel('Heights, m')
title(sprintf('Daily Mean Heights, USGS Site %s %s', ...
    renamed.ns1_colon_sourceInfo.ns1_colon_siteCode.Text, ...
    renamed.ns1_colon_sourceInfo.ns1_colon_siteName.Text))
if sum(ice) >0
    legend('Provisional data', 'Ice affected data')
else
    legend('Provisional data')
end
set(gca, 'FontSize', 16)
grid on
