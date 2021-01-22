function dc2htnosh (xmlfile)

clearvars -except xmlfile; close all
if ~exist(['rating/r', strrep(xmlfile, '.xml', '.txt')], 'file')
    ll = length(xmlfile) -4;
    if system(sprintf('sh rating.sh %s', xmlfile(1:ll)))
        error('Downloading the Rating Curve failed..')
    end
end

xstrt = xml2struct(['usgs/', xmlfile]);
rens = xstrt.ns1_colon_timeSeriesResponse.ns1_colon_timeSeries;
if length(rens) <1, error('Only one time series is available!'), end
% Find variableCode = 60 (Discharge, cubic feet per sec)
if length(rens) ==1
  if str2double(rens.ns1_colon_variable.ns1_colon_variableCode.Text) ~=60
    error('Variable is not the discharge, parameter 60!')
  end
  % variable option = mean (stats code = 3)
  if str2double(rens.ns1_colon_variable.ns1_colon_options.ns1_colon_option.Attributes.optionCode) ...
        ~=3
    error('Variable is not a daily mean!')
  end
  renamed = rens;
else
  sv = 0;
  for qq=1:length(rens)
    if str2double(rens{qq}.ns1_colon_variable.ns1_colon_variableCode.Text) ~=60
    	continue
    end
  % variable option = mean (stats code = 3)
    if str2double(rens{qq}.ns1_colon_variable.ns1_colon_options.ns1_colon_option.Attributes.optionCode) ...
        ==3
        sv = qq;
        break
    end
  end
  if sv <=0, error('No discharge data.'), end
  renamed = rens{sv};
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
ft2m = .3048;

subplot(2,1,1)
vflag = str2double(renamed.ns1_colon_variable.ns1_colon_noDataValue.Text);
arr(arr ==vflag) = NaN;
h = plot(ndate, arr, 'b.'); hold on
set(get(get(h,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off')
ind = find(flags);
plot(ndate(ind), arr(ind), 'ro')
ind = find(ice);
plot(ndate(ind), arr(ind), 'ko'); hold off
datetick ('x', 'yyyy')
xlim([datenum(1990, 1, 1), datenum(2020, 1, 1)])
set (gca, 'XTick', datenum(1990:4:2020, 1, 1))
set (gca, 'XTickLabel', (1990:4:2020).')
set(gca, 'FontSize', 18)
xlabel('Year'); ylabel('Discharge, ft^3/s')
title(sprintf('Daily Mean Discharge, USGS Site %s %s', ...
    renamed.ns1_colon_sourceInfo.ns1_colon_siteCode.Text, ...
    renamed.ns1_colon_sourceInfo.ns1_colon_siteName.Text))
legend('Provisional data', 'Ice affected data')
set(gca, 'FontSize', 16)
grid on

subplot(2,1,2)
[~, hb] = rating(xmlfile, arr);
plot(ndate, ft2m*hb, 'b.'); hold on
ind = find(flags);
if ~isempty(ind)
    [~, hb] = rating(xmlfile, arr(ind));
    plot(ndate(ind), ft2m*hb, 'ro')
end
ind = find(ice);
if ~isempty(ind)
    [~, hb] = rating(xmlfile, arr(ind));
    plot(ndate(ind), ft2m*hb, 'ko')
end
hold off
datetick ('x', 'yyyy')
xlim([datenum(1990, 1, 1), datenum(2020, 1, 1)])
set (gca, 'XTick', datenum(1990:4:2020, 1, 1))
set (gca, 'XTickLabel', (1990:4:2020).')
set(gca, 'FontSize', 18)
xlabel('Year'); ylabel('Height, m')
title ('Base Heights Converted Linearly Using Rating Curve')
set(gca, 'FontSize', 16)
grid on

end
