% flag bad itterativly flags points outside 99%confidence interval
function [RivAlt,WINSZ,SpG]=FlagBad(RivAlt,winsize);
MedianH=nanmedian(RivAlt.RivAlt.H);


switch winsize.toggle;%manual input for set window size of varying ?
    case {'manual'}
WINSZ=winsize.manual
    case{'varying'}
        if winsize.NavH %not pre-averaged
             [Y I]=sort(RivAlt.RivAlt.Yh);
        Tgaps=diff(RivAlt.RivAlt.Yh(I));
        else
        [Y I]=sort(RivAlt.RivAlt.Y);
        Tgaps=diff(RivAlt.RivAlt.Y(I));
        end
         
        AVGgap=mean(Tgaps);
        WINSZ=round(AVGgap*30);%was 7
        WINSZZ=WINSZ;
        
        
end
if winsize.NavH %not pre-averaged
[Y I] = sort(RivAlt.RivAlt.Yh);
RivAlt.RivAlt.Yh=RivAlt.RivAlt.Yh(I);
RivAlt.RivAlt.Xh=RivAlt.RivAlt.Xh(I);
RivAlt.RivAlt.Hh=RivAlt.RivAlt.Hh(I);
RivAlt.RivAlt.Hhnorm=RivAlt.RivAlt.Hhnorm(I);
RivAlt.RivAlt.flgh=zeros(1,length(RivAlt.RivAlt.Hhnorm));

LL=length(unique(RivAlt.RivAlt.Yh))-(WINSZ);%deals with window size larger then unique times vector makes one pass happen
if length(unique(RivAlt.RivAlt.Yh))-(WINSZ)<0
    LL=1;
end

for i=1:LL;
    
 
    if i==1
        startT=min(RivAlt.RivAlt.Yh)+(WINSZ/2);
        [Stpoint, stdex1]=min(abs(RivAlt.RivAlt.Yh-startT));
        Begin=RivAlt.RivAlt.Yh(stdex1)-(WINSZ/2);
        End=RivAlt.RivAlt.Yh(stdex1)+(WINSZ/2);
    else if find(unique(RivAlt.RivAlt.Yh)==RivAlt.RivAlt.Yh(stdex1))+(i-1) < length(unique(RivAlt.RivAlt.Yh));%sometime last window is one out of index this is a junk fix
        Uniquetimes=unique(RivAlt.RivAlt.Yh);
        st=find(Uniquetimes==RivAlt.RivAlt.Yh(stdex1))+(i-1);
        [Stpoint, stdex]=min(abs(RivAlt.RivAlt.Yh-Uniquetimes(st)));
        Begin=RivAlt.RivAlt.Yh(stdex)-(WINSZ/2);
        End=RivAlt.RivAlt.Yh(stdex)+(WINSZ/2);
        end
    end
    
    testrange=RivAlt.RivAlt.Yh>Begin & RivAlt.RivAlt.Yh< End;
    samplegrp=RivAlt.RivAlt.Hhnorm(testrange);
    
    testrange=RivAlt.RivAlt.Yh>Begin & RivAlt.RivAlt.Yh< End;
    samplegrp=RivAlt.RivAlt.Hhnorm(testrange);
    timeblork=RivAlt.RivAlt.Yh(testrange);
    if isempty(samplegrp)|| isnan(samplegrp(1))
    Keeploop=0;
    else
     Keeploop=1;
    end
    countz=1;
    k=1;
    while Keeploop==1;
        k=k+1;
        notFLAGGED=samplegrp>-9998;
        samplegrpg=samplegrp(notFLAGGED);
        SPG(k)=length(samplegrpg);
      
        [H,P,CI,stats] = ttest(samplegrpg,0,'alpha',.99);
        % ci limits based on VS amplitude
        
        CI(1)=CI(1)-(RivAlt.CI(2)*winsize.multiplier);
        CI(2)=CI(2)+(RivAlt.CI(1)*winsize.multiplier);
%        CI(1)=CI(1)-1.5;
%          CI(2)=CI(2)+1;
        badhigh =samplegrpg>CI(2);
        bh=samplegrpg(badhigh);
        hdif=bh-CI(2);
        mxhigh=max(hdif);
        badlow=samplegrpg < CI(1);
        bl=samplegrpg(badlow);
        ldif=CI(1)-bl;
        mxlow=max(ldif);
        if sum(badlow)+sum(badhigh)>0 && countz<50;
            if isempty(bl)
                mxlow=0;
            end
            if isempty (bh)
                mxhigh=0;
            end
            if mxhigh>mxlow
                RP=find(samplegrp==(mxhigh+CI(2)));
            else
                RP=find(samplegrp==(CI(1)-mxlow(1)));
            end
            samplegrp(RP)=-9998;
            Keeploop=1;
            countz=countz+1;
        else
            Keeploop=0;
            
        end
    end
    SpG.SPG=SPG;
    %flagthe altdat
    BADZ=samplegrp<-9900;
    [I,J,V] = find(testrange>0);
    change=J(BADZ);
    if~isempty(change)
        
    RivAlt.RivAlt.flgh(change)=-9995;
    end
end
else
[Y I] = sort(RivAlt.RivAlt.Y);
RivAlt.RivAlt.Y=RivAlt.RivAlt.Y(I);
RivAlt.RivAlt.X=RivAlt.RivAlt.X(I);
RivAlt.RivAlt.H=RivAlt.RivAlt.H(I);
RivAlt.RivAlt.Hnorm=RivAlt.RivAlt.Hnorm(I);
RivAlt.RivAlt.flg=zeros(1,length(RivAlt.RivAlt.Hnorm));

for i=1:length(unique(RivAlt.RivAlt.Y))-WINSZ;
    
    if i==1
        startT=min(RivAlt.RivAlt.Y)+(WINSZ/2);
        [Stpoint, stdex1]=min(abs(RivAlt.RivAlt.Y-startT));
        Begin=RivAlt.RivAlt.Y(stdex1)-(WINSZ/2);
        End=RivAlt.RivAlt.Y(stdex1)+(WINSZ/2);
    else
        Uniquetimes=unique(RivAlt.RivAlt.Y);
        st=find(Uniquetimes==RivAlt.RivAlt.Y(stdex1))+(i-1);
        [Stpoint, stdex]=min(abs(RivAlt.RivAlt.Y-Uniquetimes(st)));
        Begin=RivAlt.RivAlt.Y(stdex)-(WINSZ/2);
        End=RivAlt.RivAlt.Y(stdex)+(WINSZ/2);
    end
    
    testrange=RivAlt.RivAlt.Y>Begin & RivAlt.RivAlt.Y< End;
    samplegrp=RivAlt.RivAlt.Hnorm(testrange);
    
    testrange=RivAlt.RivAlt.Y>Begin & RivAlt.RivAlt.Y< End;
    samplegrp=RivAlt.RivAlt.Hnorm(testrange);
    timeblork=RivAlt.RivAlt.Y(testrange);
    Keeploop=1;
    countz=1;
    k=1;
    while Keeploop==1;
        k=k+1;
        notFLAGGED=samplegrp>-9998;
        samplegrpg=samplegrp(notFLAGGED);
        SPG(k)=length(samplegrpg);
        [H,P,CI,stats] = ttest(samplegrpg,0,'alpha',.99);
        % ci limits based on VS amplitude
        CI(1)=CI(1)-(RivAlt.CI(2)*winsize.multiplier);
        CI(2)=CI(2)+(RivAlt.CI(1)*winsize.multiplier);
%        CI(1)=CI(1)-1.5;
%          CI(2)=CI(2)+1;
        badhigh =samplegrpg>CI(2);
        bh=samplegrpg(badhigh);
        hdif=bh-CI(2);
        mxhigh=max(hdif);
        badlow=samplegrpg < CI(1);
        bl=samplegrpg(badlow);
        ldif=CI(1)-bl;
        mxlow=max(ldif);
        if sum(badlow)+sum(badhigh)>0 && countz<50;
            if isempty(bl)
                mxlow=0;
            end
            if isempty (bh)
                mxhigh=0;
            end
            if mxhigh>mxlow
                RP=find(samplegrp==(mxhigh+CI(2)));
            else
                RP=find(samplegrp==(CI(1)-mxlow(1)));
            end
            samplegrp(RP)=-9998;
            Keeploop=1;
            countz=countz+1;
        else
            Keeploop=0;
            
        end
    end
    SpG.SPG=SPG;
    %flagthe altdat
    BADZ=samplegrp<-9900;
    [I,J,V] = find(testrange>0);
    change=J(BADZ);
    if~isempty(change)
        
    RivAlt.RivAlt.flg(change)=-9995;
    end
end
end
