function dc2ht (xmlfile, xstrt, lat, lon,Toggle,RIV)

clearvars -except Toggle xmlfile xstrt lat lon RIV; close all
if ~exist(fullfile(Toggle.USGSlistdir,['rating/r', strrep(xmlfile, '.xml', '.txt')]), 'file')
    ll = length(xmlfile) -4;
    if system(sprintf('sh rating.sh %s', xmlfile(1:ll)))
        error('Downloading the Rating Curve failed..')
    end
end

ll = length(xmlfile) -4;
ofile = [RIV, xmlfile(1:ll),'CY','.mat'];

rens = xstrt.Children;
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
  for qq=2:length(rens)
    strt = rens(qq).Attributes(1).Value;
    if str2double(rens(qq).Children(2).Children(1).Children.Data) ~=60
    	continue
    end
  % variable option = mean (stats code = 3)
    if str2double(strt(ll+13:end)) ==3
        sv = qq;
        break
    end
  end
  if sv <=0, error('No discharge data.'), end
  renamed = rens(sv);
end
if isempty(strfind(renamed.Name, 'timeSeries'))
    error('dc2ht: Not a Time series!')
end
if isempty(strfind(renamed.Children(3).Name, 'values'))
    error('dc2ht: No Time series data!')
end

ll = length(renamed.Children(3).Children);
arr = NaN(ll,1); qq = 0;
ndate = NaN(ll,1); flags = NaN(ll,1); ice = NaN(ll,1);
for pp=1:ll
    if isempty(strfind(renamed.Children(3).Children(pp).Attributes(1).Name, 'dateTime')) || ...
       isempty(strfind(renamed.Children(3).Children(pp).Attributes(2).Name, 'qualifiers'))
        continue
    end
    qq = qq +1;
    arr(qq) = str2double(renamed.Children(3).Children(pp).Children.Data);
    ndate(qq) = datenum(renamed.Children(3).Children(pp).Attributes(1).Value, ...
        'yyyy-mm-ddTHH:MM:SS.FFF');
    flags(qq) = any('P' ==renamed.Children(3).Children(pp).Attributes(2).Value);
      ice(qq) = any('I' ==renamed.Children(3).Children(pp).Attributes(2).Value);
end
ft2m = .3048;

subplot(2,1,1)
if isempty(strfind(renamed.Children(2).Children(7).Name, 'noDataValue'))
    error('dc2ht: noDataValue not found!')
end
vflag = str2double(renamed.Children(2).Children(7).Children.Data);
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
    renamed.Children(1).Children(2).Children.Data, ...
    renamed.Children(1).Children(1).Children.Data))
legend('Provisional data', 'Ice affected data')
set(gca, 'FontSize', 16)
grid on

[hb, ~] = rating(xmlfile, arr,Toggle);
if isempty(hb), error('No Rating Curve!!'), end
subplot(2,1,2)
if any(isnan(hb(~isnan(arr))))
    fprintf('Run ghxt instead if Rating Curve needs Extrapolation!\n')
end
hbuf = ft2m*hb(1:qq);
ndate = ndate(1:qq);
flags = flags(1:qq);
ice   =   ice(1:qq);
plot(ndate, hbuf, 'b.'); hold on
ind = find(flags);
if ~isempty(ind)
    plot(ndate(ind), hbuf(ind), 'ro')
end
ind = find(ice);
if ~isempty(ind)
    plot(ndate(ind), hbuf(ind), 'ko')
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
%rep = input(sprintf('Save the heights to out/%s (y/n) ? ', ofile), 's');
%if rep(1:1) =='y' || rep(1:1) =='Y'
DATE=ndate;Lat=lat;Lon=lon;stage=hbuf;
    save(fullfile(Toggle.Validdir,[ofile]), 'DATE', 'stage', 'flags', 'ice', 'Lat', 'Lon')
%end

end
