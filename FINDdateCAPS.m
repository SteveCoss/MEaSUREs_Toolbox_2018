%finddatecpas is a sub function of validate 2.0 that scrubs data for
%comparison
function [LIMITS]=FINDdateCAPS(VS,gagedata,vsnum);
DATE=gagedata.DATE;
stage=gagedata.stage;

%% start date
% start by finding the closest date of the gage to the bigining of the VS
[gagestdex,adwd]=min(abs(min(VS(vsnum).AltDat.t)-gagedata.DATE));
%verify that there isnt a large gap
datedifs=diff(gagedata.DATE);
normaldiff=mode(datedifs);
if adwd<length(datedifs)&& VS(vsnum).AltDat.Write%makes sure the closest date isnt the lasts (gage is before the VS in time)
    if datedifs(adwd)>normaldiff;
        adwd=adwd+1;%if seeking the start point led to the other side of a gap, move over one
    end
    if min(VS(vsnum).AltDat.t)<gagedata.DATE(adwd);
        stdate=gagedata.DATE(adwd);
    else
        stdate=min(VS(vsnum).AltDat.t);
    end
    %end date
    if max(VS(vsnum).AltDat.t)>max(DATE);
        enddate=max(DATE);
    else
        enddate=max(VS(vsnum).AltDat.t);
    end
    LIMITS.stdate=stdate;
    LIMITS.enddate=enddate;
    %% indexing with above limits
    USdatedexst= find(DATE>=stdate);%after gage start
    USdatedexend=find(DATE<=enddate);%before gage end
    if ~isempty(USdatedexst)
        if ~isempty(USdatedexend)
            %gage
            LIMITS.USGST=DATE(intersect(USdatedexst,USdatedexend));%plot time gage
            LIMITS.USGSH=stage(intersect(USdatedexst,USdatedexend));%plot stage gage
            VSdatedexst= find(VS(vsnum).AltDat.t>stdate);%after VS start
            VSdatedexend=find (VS(vsnum).AltDat.t<enddate);%before VS end
            %VS
            LIMITS.VST= VS(vsnum).AltDat.t(intersect(VSdatedexst,VSdatedexend));%plot time VS
            LIMITS.VSH=VS(vsnum).AltDat.hbar(intersect(VSdatedexst,VSdatedexend));%plot elevation VS
            if ~isnan(nansum( LIMITS.VSH));
                %need to remove ice flags
                icedex=  LIMITS.VSH>-9998;
                LIMITS.VSTslim= LIMITS.VST(icedex);
                LIMITS.VSHslim= LIMITS.VSH(icedex);
            end
        end
        
    end
    if ~isfield(LIMITS,'VST') || isempty(LIMITS.VST)||isempty(LIMITS.VSTslim)
        LIMITS=[];
    end
    
    
    
else
    LIMITS=[];
end
end