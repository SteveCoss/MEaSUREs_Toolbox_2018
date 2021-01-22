%gageloader-sunfunction for validation tester2.0
function [gagedata]=gageloader2(flist,VS,Toggle)
k=0;
for i=1:length(flist)
    if flist(i).bytes>0
        if length(flist(i).name)>=length(VS(1).Riv) && strcmp(flist(i).name(1:length(VS(1).Riv)),VS(1).Riv);
        gagedataUP=load(fullfile(Toggle.Validdir ,flist(i).name)); % load files in workspace
        if ~isfield(gagedataUP,'GageFLdist') ||~isfield(gagedataUP,'Station')||~isfield(gagedataUP,'RIVER')
            %add flow distance if there is none
            [gagedataUP] = ADDfd2gage(gagedataUP,VS(1).Riv,flist(i).name,fullfile(Toggle.Validdir ,flist(i).name));
%             save(fullfile(Toggle.Validdir ,flist(i).name),'gagedataUP');
        end
        if isfield(gagedataUP,'Lon')
            gagedataUP=rmfield(gagedataUP,'Lon');
            gagedataUP=rmfield(gagedataUP,'Lat');
        end
        if isfield(gagedataUP,'Vsat')
            gagedataUP=rmfield(gagedataUP,'Vsat');
            gagedataUP=rmfield(gagedataUP,'Vstation');
        end
        if isfield(gagedataUP,'date')
            gagedataUP=rmfield(gagedataUP,'date');
        end
        if~isempty(gagedataUP.DATE);
              k=k+1;
        gagedata(k).DATE = gagedataUP.DATE;
        gagedata(k).GageFLdist = gagedataUP.GageFLdist;
        gagedata(k).stage = gagedataUP.stage;
        gagedata(k).RIVER = gagedataUP.RIVER;
        gagedata(k).Station = gagedataUP.Station;
        end
        end
    end
end
if ~exist('gagedata','var')
    disp(strcat('The_',VS(1).Riv,' river has no gages and requires qualitative grading.'));
    gagedata =[];
end
