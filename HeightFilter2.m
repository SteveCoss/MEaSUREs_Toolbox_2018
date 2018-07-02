%% flood height filter
%returns the indices of heights that are outside flood boundaries (DEM +
%maximum flood level
%
% by Steve T, Feb 2015
% rev Mike D, Mar 2015
% rev Steve T, May 2015

function [Altimetry] = HeightFilter(Altimetry,S,FilterData,IceData,DoIce,ID,varargin)


%% use absolute height data and an arbitary max flood value to
Altimetry.iGoodH=Altimetry.h>=FilterData.MinFlood &...
    Altimetry.h<=FilterData.MaxFlood; %filter relative to absolute river height (+15m, -10m)

iH2=Altimetry.h>=prctile(Altimetry.h(Altimetry.iGoodH),5)-2; %filter relative to baseflow (>-2m 5th %tile flow)

Altimetry.iGoodH=Altimetry.iGoodH&iH2; %combine height filters
%ih3=Altimetry.sig0>20;
%Altimetry.iGoodH=Altimetry.iGoodH&ih3;
Altimetry.fFilter=(sum(~Altimetry.iGoodH))/length(Altimetry.h); %determine fraction of retrieved data filtered out

%%
if DoIce %& sum(Altimetry.iGoodH)/((max(Altimetry.tAll)-min(Altimetry.tAll))/365)>=5,
    Altimetry=IceFilter(Altimetry,IceData);
    if~isempty(Altimetry.IceFlag) && length(Altimetry.iGoodH)==length(Altimetry.IceFlag)
    Altimetry.iGood=Altimetry.iGoodH&Altimetry.IceFlag;
    else
        C = strsplit(ID,'_');
     sprintf(strcat('The ice sheet for the_',C{1},'_river does not cover the date range of_',ID))
    Altimetry.iGood=Altimetry.iGoodH;
    Altimetry.IceFlag=ones(length(Altimetry.h),1);
    end
else
    Altimetry.iGood=Altimetry.iGoodH;
    Altimetry.IceFlag=ones(length(Altimetry.h),1);
end

Altimetry.iFilter=sum(~Altimetry.iGood)/length(Altimetry.h);


return
