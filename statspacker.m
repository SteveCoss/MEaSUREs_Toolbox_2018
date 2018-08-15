%statspacker, packages statoutputs
function [Stats]=statspacker(VS,j,pstats,LIMITS,gagedata)
E=pstats.E;
STDE=pstats.STDE;
R=pstats.R;
AltHslim=LIMITS.VSHslim;
offset=LIMITS.offset;
GageFLdist=gagedata.GageFLdist;
%%
 Stats.ID=VS(j).ID;
    Stats.offset=offset;
    if length(AltHslim)>1
        Stats.E=E;
        Stats.STD=STDE;
        Stats.R=R;
    else
        Stats.E=[];
        Stats.STD=[];
         Stats.R=[];
    end
    Stats.FLOW_Dist=VS(j).FLOW_Dist;
    Stats.Width=VS(j).Width;
    Stats.precentgood=VS(j).AltDat.nGood/VS(j).AltDat.cmax;
    Stats.GageFLdist=GageFLdist;
    Stats.proximity=round(((GageFLdist-VS(j).FLOW_Dist)/1000),0);%distance in km
    Stats.Id=VS(j).Id;
    %% ST
    if isfield(pstats,'ST')
    E=pstats.ST.E;
STDE=pstats.ST.STDE;
R=pstats.ST.R;
AltHslim=LIMITS.VSHstslim;
offset=LIMITS.offsetST;

%%
 Stats.ID=VS(j).ID;
    Stats.offset=offset;
    if length(AltHslim)>1
        Stats.Est=E;
        Stats.STDst=STDE;
        Stats.Rst=R;
    else
        Stats.Est=Stats.E;
        Stats.STDst=Stats.STD;
         Stats.Rst=Stats.R;
    end
    else
         Stats.Est=E;
        Stats.STDst=STDE;
         Stats.Rst=R;
    end
end
