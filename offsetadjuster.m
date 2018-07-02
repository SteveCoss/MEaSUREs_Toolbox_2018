%offsetadjuster subfunction of validation tester for offset removal
function [LIMITS]= offsetadjuster(LIMITS)
USGST=LIMITS.USGST;
USGSH=LIMITS.USGSH;
AltTslim=LIMITS.VSTslim;
AltHslim=LIMITS.VSHslim;

for i= 1:length(AltTslim)
[Ydex(i), Idex(i)]=min(abs(USGST-AltTslim(i)));
end


for i = 1:length(Idex)
    diffs(i)=abs(AltHslim(i)-USGSH(Idex(i)));
end
offset=nanmean(diffs);
if nanmedian(AltHslim)>nanmedian(USGSH(Idex));
    LIMITS.USGSH=USGSH+offset;
else
     LIMITS.USGSH=USGSH-offset;
end
LIMITS.Idex=Idex;
LIMITS.offset=offset;
end