%offsetadjuster subfunction of validation tester for offset removal
function [LIMITS]= offsetadjuster(LIMITS)
USGST=LIMITS.USGST;
USGSH=LIMITS.USGSH;
AltTslim=LIMITS.VSTslim;
AltHslim=LIMITS.VSHslim;
AltHslimst=LIMITS.VSHstslim;

for i= 1:length(AltTslim)
[Ydex(i), Idex(i)]=min(abs(USGST-AltTslim(i)));
end


for i = 1:length(Idex)
    diffs(i)=abs(AltHslim(i)-USGSH(Idex(i)));
     diffsST(i)=abs(AltHslimst(i)-USGSH(Idex(i)));
end
offset=nanmean(diffs);
offsetST=nanmean(diffsST);
if nanmedian(AltHslim)>nanmedian(USGSH(Idex));
    LIMITS.USGSH=USGSH+offset;
else
     LIMITS.USGSH=USGSH-offset;
end
if nanmedian(AltHslimst)>nanmedian(USGSH(Idex));
    LIMITS.USGSHst=USGSH+offsetST;
else
     LIMITS.USGSHst=USGSH-offsetST;
end
LIMITS.Idex=Idex;
LIMITS.offset=offset;
LIMITS.offsetST=offsetST;
end