%Meansurface
%Created By Steve Coss
% Remove TS means then adds reference DEM height
function [VS] =Meansurface(VS);
for i=1:length(VS)%jason
    if isfield(VS(i).AltDat,'hbar')&& ~isempty(VS(i).AltDat.hbar);
        hbar=VS(i).AltDat.hbar;
        h=VS(i).AltDat.h;
        goodh=VS(i).AltDat.iGood;
        goodhbar=hbar>-9900;
        TSmean=nanmean(hbar(goodhbar));
        hmean=nanmean(h(goodh));
        anomj=hbar(goodhbar)-TSmean;
        Gdex=find(goodhbar==1);
        Bdex=find(goodhbar==0);
        %VS(i).AltDat.hbar(Gdex)=anomj;
        VS(i).AltDat.hanom =  VS(i).AltDat.h-hmean;
        VS(i).AltDat.MeanRemoved=hmean;% we only care about pre pass averae mean
    end
    
end