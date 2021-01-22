function pltgh(file)

clearvars -except file; close all

load (sprintf('out/%s.mat', file))

h = plot(ndate, hbuf, 'b.'); hold on
set(get(get(h,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off')
ind = find(flags);
plot(ndate(ind), hbuf(ind), 'ro')
ind = find(ice);
plot(ndate(ind), hbuf(ind), 'ko'); hold off
datetick ('x', 'yyyy')
if min(ndate) <datenum(2000, 1, 1)
xlim([datenum(1990, 1, 1), datenum(2020, 1, 1)])
set (gca, 'XTick', datenum(1990:4:2020, 1, 1))
set (gca, 'XTickLabel', (1990:4:2020).')
else
set (gca, 'XTick', datenum(2000:2:2020, 1, 1))
set (gca, 'XTickLabel', ...
    [2000;2002;2004;2006;2008;2010;2012;2014;2016;2018;2020])
end
set(gca, 'FontSize', 18)
xlabel('Year'); ylabel('Heights, m')
title(sprintf('Daily Mean Heights, USGS Site %s, Lat=%f, Lon=%f', ...
    file, lat, lon))
if sum(ice) >0
    legend('Provisional data', 'Ice affected data')
else
    legend('Provisional data')
end
set(gca, 'FontSize', 16)
grid on

end
