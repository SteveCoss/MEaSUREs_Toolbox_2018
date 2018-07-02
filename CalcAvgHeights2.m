function Altimetry = CalcAvgHeights(ABSheight,Altimetry,ID,IceData)



Altimetry.nNODATA=0;
Altimetry.NDcyc=[];
Altimetry.NDflag=[];

if sum(Altimetry.GDRMissing)==length(Altimetry.GDRMissing)
    
    Altimetry.hbar=0;Altimetry.hstd=0;Altimetry.N=0;Altimetry.hwbar=0;
    Altimetry.sig0Avg=0;Altimetry.pkAvg=0; Altimetry.Write=0; 
    Altimetry.hsig0cut=0;
    
else
    
    
    for j=1:length(Altimetry.ci),
        
        ic=Altimetry.c==Altimetry.ci(j);
        ig=Altimetry.iGood;
        icg=ic&ig;
        
        
        if ~any(icg),
            Altimetry.nNODATA=Altimetry.nNODATA+1;
            Altimetry.NDcyc=[Altimetry.NDcyc Altimetry.ci(j)];
            
            if ~any(ic),
                ERRORCODE=-9999; %no data in the GDR
                Altimetry.NDcyc=[Altimetry.NDcyc 2];
            else
                ERRORCODE=-9998; %all records filtered out from height/ice filter
                Altimetry.NDcyc=[Altimetry.NDcyc 0];        %need to work on this more
            end
            Altimetry.hbar(j)=ERRORCODE;
            Altimetry.hsig0cut=ERRORCODE;
            Altimetry.hstd(j)=ERRORCODE;
            Altimetry.N(j)=0;
            Altimetry.hwbar(j)=ERRORCODE;
            Altimetry.sig0Avg(j)=ERRORCODE;
            Altimetry.pkAvg(j)=ERRORCODE;
              Altimetry.hwDEMbar(j)=ERRORCODE;
        else
            hc=Altimetry.h(icg);
            sc=Altimetry.sig0(icg);
            pk=Altimetry.PK(icg);
            
            %% look into outlier removal in hc prior to averaging
            [ refheight, DX]=(min(abs((hc-ABSheight))));
            diffs=abs(hc-hc(DX));
            [difz rank]=sort(diffs,'descend');
            
             Altimetry.hwDEMbar(j)=nansum(hc.*10.^(.1.*rank))./sum(10.^(.1.*rank));
            Altimetry.hbar(j)=nanmean(hc);
            Altimetry.hstd(j)=nanstd(hc);
            Altimetry.N(j)=sum(icg);
            
            Altimetry.hwbar(j)=sum(hc.*10.^(.1.*sc))./sum(10.^(.1.*sc));
            
            Altimetry.sig0Avg(j)=mean(sc);
            
            Altimetry.pkAvg(j)=mean(pk);
        end
    end
    
    
    Altimetry.nGood=sum(Altimetry.hbar~=-9999 & Altimetry.hbar~=-9998);
    
   
    end
    
    if Altimetry.nGood/Altimetry.cmax<=0.50 && isempty(IceData)
        Altimetry.Write=0;
    else if Altimetry.nGood/Altimetry.cmax<=0.25 && ~isempty(IceData)
            Altimetry.Write=0;
        else
            Altimetry.Write=1;
        end
    end
    
end