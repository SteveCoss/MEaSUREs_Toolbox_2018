%allriver extractor
%sub funciton of InterpV2 for extracting all river Alt data 
function [RivAlt]=allriverextractor(VS,loadswitch);
k=0;
r=0;
for i=1:length(VS)
    if loadswitch.GRRATSONY==true;
        if isfield(VS(i).AltDat,'Write') & VS(i).AltDat.Write==1
            if isfield(VS(i).AltDat,'hbar')
                flowd(i)=VS(i).FLOW_Dist;
                RivLocations(i).FLD=flowd(i);
                RivLocations(i).BLH=VS(i).AltDat.AbsHeight;
                for j=1:length(VS(i).AltDat.hbar);
                    if VS(i).AltDat.hbar(j) > -9995,
                        k=k+1;
                        RivAltt.X(k)=flowd(i);
                        RivAltt.Y(k)=VS(i).AltDat.t(j);
                        RivAltt.H(k)=VS(i).AltDat.hbar(j);
                        RivAltt.VSNUM(k)= i;
                        if isfield(VS(i).AltDat,'MeanRemoved')
                        RivAltt.MeanRemoved(k)=VS(i).AltDat.MeanRemoved;
                        end
                    end
                    
                    
                end
                for m = 1:length(VS(i).AltDat.h);
                    if VS(i).AltDat.iGood(m)== 1;
                        r=r+1;
                        RivAltt.Yh(r)=VS(i).AltDat.tAll(m);
                        RivAltt.Hh(r)=VS(i).AltDat.hanom(m);
                        RivAltt.Xh(r)=flowd(i);
                        RivAltt.VSNUMh(r)= i;
                    end
                end
                
                
                
            end
            
        end
    else
        if isfield(VS(i).AltDat,'hbar')
            flowd(i)=VS(i).FLOW_Dist;
            RivLocations(i).FLD=flowd(i);
            RivLocations(i).BLH=VS(i).AltDat.AbsHeight;           
            for j=1:length(VS(i).AltDat.hbar);
                if VS(i).AltDat.hbar(j) > -9995
                    k=k+1;
                    RivAltt.X(k)=flowd(i);
                    RivAltt.Y(k)=VS(i).AltDat.t(j);
                    RivAltt.H(k)=VS(i).AltDat.hbar(j);                   
                    RivAltt.VSNUM(k)= i;
                    RivAltt.MeanRemoved(k)=VS(i).AltDat.MeanRemoved;
                end
            end
            for m = 1:length(VS(i).AltDat.h);
                if VS(i).AltDat.iGood(m)== 1;
                    r=r+1;
                    RivAltt.Yh(r)=VS(i).AltDat.tAll(m);
                    RivAltt.Hh(r)=VS(i).AltDat.hanom(m);
                    RivAltt.Xh(r)=flowd(i);
                    RivAltt.VSNUMh(r)= i;
                    
                end
            end
            
            
        end
        
    end
end

%% constreign Baseline Elevations
[RivLocations] =CBelevationsINTERP(RivLocations);
RivAlt.RivAlt=RivAltt;
RivAlt.RivLocations=RivLocations;
end
