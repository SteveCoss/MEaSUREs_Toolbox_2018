%pstats calclates fit statistics
function [pstats]=plotstats(LIMITS)
AltHslim=LIMITS.VSHslim;
AltHslimST=LIMITS.VSHstslim;
USGSH=LIMITS.USGSH;
Idex=LIMITS.Idex;
%stats
RMSE = sqrt(nanmean((AltHslim' - USGSH(Idex)).^2)) ; % Root Mean Squared Error
pstats.RMSE=round(RMSE,2);
STDE=nanstd(AltHslim' - USGSH(Idex));
pstats.STDE=round(STDE,2);
R=corrcoef(AltHslim,USGSH(Idex),'rows','complete');
if numel(R)==4
    pstats.R=R(2);
else
    pstats.R=nan;
end
USGSHhat=nanmean(USGSH(Idex));
clear top bottom
for i=1:length(Idex)
    top(i)=(USGSH(Idex(i))-AltHslim(i))^2;
    bottom(i)=(USGSH(Idex(i))-USGSHhat)^2;
end
E=1-((nansum(top))/(nansum(bottom)));
pstats.E=round(E,2);

%stats for hbarST
if sum(isnan(LIMITS.VSHstslim)) <length(LIMITS.VSHstslim)
    RMSE = sqrt(nanmean((AltHslimST' - USGSH(Idex)).^2)) ; % Root Mean Squared Error
pstats.ST.RMSE=round(RMSE,2);
STDE=nanstd(AltHslimST' - USGSH(Idex));
pstats.ST.STDE=round(STDE,2);
R=corrcoef(AltHslimST,USGSH(Idex),'rows','complete');
if numel(R)==4
    pstats.ST.R=R(2);
else
    pstats.ST.R=nan;
end
USGSHhat=nanmean(USGSH(Idex));
clear top bottom
for i=1:length(Idex)
    top(i)=(USGSH(Idex(i))-AltHslimST(i))^2;
    bottom(i)=(USGSH(Idex(i))-USGSHhat)^2;
end
E=1-((nansum(top))/(nansum(bottom)));
pstats.ST.E=round(E,2);
    
end
end