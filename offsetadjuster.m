%offsetadjuster subfunction of validation tester for offset removal
function [LIMITS]= offsetadjuster(LIMITS,Toggle)
USGST=LIMITS.USGST;
USGSH=LIMITS.USGSH;
AltTslim=LIMITS.VSTslim;
AltHslim=LIMITS.VSHslim;
if Toggle.SF
AltHslimst=LIMITS.VSHstslim;
end
for i= 1:length(AltTslim)
[Ydex(i), Idex(i)]=min(abs(USGST-AltTslim(i)));
end


for i = 1:length(Idex)
    diffs(i)=abs(AltHslim(i)-USGSH(Idex(i)));
    if Toggle.SF
     diffsST(i)=abs(AltHslimst(i)-USGSH(Idex(i)));
    end
end
offset=nanmean(diffs);
if Toggle.SF
offsetST=nanmean(diffsST);
 end
if nanmedian(AltHslim)>nanmedian(USGSH(Idex));
    LIMITS.USGSH=USGSH+offset;
else
     LIMITS.USGSH=USGSH-offset;
end
if  Toggle.SF
if nanmedian(AltHslimst)>nanmedian(USGSH(Idex));
    LIMITS.USGSHst=USGSH+offsetST;
else
     LIMITS.USGSHst=USGSH-offsetST;
end
end
LIMITS.Idex=Idex;
LIMITS.offset=offset;
if Toggle.SF
LIMITS.offsetST=offsetST;
end
end