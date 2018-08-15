function [VSpack] = VSsorter(VS,loadswitch)
R={VS.Riv};
Riv=unique(R(find(~cellfun(@isempty,R))));
SATZ = {VS.Satellite};
SATZZ= unique(SATZ);

for i = 1:length(SATZZ);
    k=1;
    for j = 1: length(VS)
        if strfind(VS(j).ID,SATZZ{i})
            VSpack(i).VS(k)=VS(j);
            k=k+1;
        end
    end
    %% save unique VS
    SVVS=VSpack(i).VS;
    Fname=fullfile(loadswitch.VSdir,strcat(Riv{1},SATZZ{i},'VS_SF'));
    save(Fname,'SVVS');
end
end