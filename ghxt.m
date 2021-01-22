function ghxt(xmlfile)

clearvars -except xmlfile; close all

ll = length(xmlfile) -4;
if ~exist(['usgs/', xmlfile], 'file')
    if system(sprintf('sh usgs.sh %s', xmlfile(1:ll)))
        error('Downloading USGS WaterML file failed..')
    end
end
ofile = [xmlfile(1:ll), '.mat'];

xstrt = xml2struct(['usgs/', xmlfile]);
rens = xstrt.Children;
tsl = length(rens);
if tsl <=1
    if isempty(strfind(rens.Name, 'timeSeries'))
        error('Not a Time series found in %s!', xmlfile)
    end
    error('Unknown Time Series Data!')
else
    vcode = zeros(tsl-1,1);
    for qq=2:tsl
        tt = qq -1;
        %strt = 'USGS:01578310:00060:00003' for example
        strt = rens(qq).Attributes(1).Value;
        if ~strcmp(strt(1:ll+5), ['USGS:', xmlfile(1:ll)])
            error ('gh: Wrong Site ID, Time Series %d!', tt)
        end
        vcode(tt) = str2double(strt(ll+7:ll+11));
        %vcode(tt) = str2double(rens(qq).Children(2).Children(1).Children.Data);
        % variable option = mean (stats code = 3)
        if str2double(strt(ll+13:end)) ...
        ~=3
            vcode(tt) = 0;
            continue
        end
    end
    if isempty(strfind(rens(qq).Children(1).Children(4).Children.Name, ...
            'geogLocation'))
        error('No Geographical Location of Site found!!')
    end
    srcinfo{1} = rens(qq).Children(1).Children(4).Children.Children(1).Name;
    srcinfo{2} = rens(qq).Children(1).Children(4).Children.Children(2).Name;
    if isempty(strfind(srcinfo{1}, 'latitude')) || ...
       isempty(strfind(srcinfo{2}, 'longitude'))
        error('No Latitude or Longitude of Site found!!')
    end
    lat = str2double(rens(qq).Children(1).Children(4).Children.Children(1).Children.Data);
    lon = str2double(rens(qq).Children(1).Children(4).Children.Children(2).Children.Data);
    
    ind = find(vcode ==65);
    if isempty(ind)
        if isempty(find(vcode ==60,1))
            error('No daily mean discharge or gage height!!')
        end
        fprintf('Discharge data found; Calling dc2htxt.\n')
        dc2htxt(xmlfile, xstrt, lat, lon); return
    else
        fprintf('Gage heights found.\n')
        renamed = rens(ind(1)+1);
    end
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

if isempty(strfind(renamed.Children(2).Children(7).Name, 'noDataValue'))
    error('gh: noDataValue not found!')
end
vflag = str2double(renamed.Children(2).Children(7).Children.Data);
arr(arr ==vflag) = NaN;
ft2m = .3048;
hbuf = arr(1:qq)*ft2m;
ndate = ndate(1:qq);
flags = flags(1:qq);
ice   =   ice(1:qq);
h = plot(ndate, hbuf, 'b.'); hold on
set(get(get(h,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off')
ind = find(flags);
plot(ndate(ind), hbuf(ind), 'ro')
ind = find(ice);
plot(ndate(ind), hbuf(ind), 'ko'); hold off
datetick ('x', 'yyyy')
set (gca, 'XTick', datenum(2000:2:2020, 1, 1))
set (gca, 'XTickLabel', ...
    [2000;2002;2004;2006;2008;2010;2012;2014;2016;2018;2020])
set(gca, 'FontSize', 18)
xlabel('Year'); ylabel('Heights, m')
title(sprintf('Daily Mean Heights, USGS Site %s %s', ...
    renamed.Children(1).Children(2).Children.Data, ...
    renamed.Children(1).Children(1).Children.Data))
if sum(ice) >0
    legend('Provisional data', 'Ice affected data')
else
    legend('Provisional data')
end
set(gca, 'FontSize', 16)
grid on
% rep = input(sprintf('Save the heights to out/%s (y/n) ? ', ofile), 's');
% if rep(1:1) =='y' || rep(1:1) =='Y'
DATE=ndate;Lat=lat;Lon=lon;stage=hbuf;
    save(['out/', ofile], 'Date', 'stage', 'flags', 'ice', 'Lat', 'Lon')
% end

end
