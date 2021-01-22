%statsaver saves the stats
function statsaver(Stats,gagedata,Toggle,VS)
RunRiv=gagedata.RIVER;
Satellite=VS(1).Satellite;
Station=gagedata.Station;
%get rid of empty
Stats=[Stats.STATS];
if exist('Stats','var')
    if iscell(Station)
    filenamestats=(strcat(RunRiv,Satellite,cell2mat(Station(3)),'stats'));    
    Filenames=fullfile(Toggle.Statsdir,(filenamestats));
    else
         filenamestats=(strcat(RunRiv,Satellite,Station,'stats'));    
    Filenames=fullfile(Toggle.Statsdir,(filenamestats));
    end
end

save(Filenames,'Stats');
end