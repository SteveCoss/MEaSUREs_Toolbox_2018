% Validation tester2.0
function Validation_tester_GC(VS,Toggle)
flist=dir(Toggle.Validdir);%this creates a list of all gage data

%% load relevant gage data

[gagedata]=gageloader2(flist,VS,Toggle);
if ~isempty(gagedata);
    %%load VS
    for m = 1:length(gagedata)
        %% run items per vs
        for j=1:length(VS)
            if ~isempty(VS(j).AltDat) && ~isempty(VS(j).AltDat.c)
                %% date caps
                [LIMITS]=FINDdateCAPS(VS,gagedata(m),j,Toggle);
                %offset
                if ~isempty(LIMITS) && ~isempty(LIMITS.VSTslim) %this happens if gage does not match temporally with VS
                    [LIMITS]= offsetadjuster(LIMITS,Toggle);
                    [pstats]=plotstats(LIMITS);
                    %% pack stats into a structure
                    [Stats(j).STATS]=statspacker(VS,j,pstats,LIMITS,gagedata(m));
                end
            end
        end
        %% save
        
        if  exist('Stats','var') && ~isempty(Stats)
            statsaver(Stats,gagedata(m),Toggle,VS)
            clear Stats
        end
    end
end
end