
%make VS V 3 by altering VS with densification flags
function [VSpack] = ALTERVS_SF(VS,RivAlt,winsize,loadswitch)
if winsize.NavH
    for i=1: length(VS)
        
        FLGdex=find(RivAlt.RivAlt.VSNUMh==(i));
        if ~isempty(FLGdex);
            USEh= RivAlt.RivAlt.flgh(FLGdex) > -9995 ;%index of iGood values that pass v3 filter
            USEhVS=VS(i).AltDat.h(find(VS(i).AltDat.iGood==1));%origional VS H valus for taking the mean of the entire VS
            USEcVS=(VS(i).AltDat.c(find(VS(i).AltDat.iGood==1)));%origional VS T valus for taking the mean of the entire VS
            Cycles = unique(USEcVS);
            clear V3hbarz
            for j = 1:length(Cycles)
                thisC= USEcVS==Cycles(j);
                premeang = USEh+thisC';
                meang = premeang ==2;
                V3hbarz(j)=mean(USEhVS(meang));
              
            end
            VS(i).AltDat.V3hbar= VS(i).AltDat.hbar;
            filz= VS(i).AltDat.V3hbar== -9998;
            VS(i).AltDat.V3hbar(~filz)= V3hbarz;
            %VS(i).AltDat.V3hbar= VS(i).AltDat.V3hbar+ VS(i).AltDat.AbsHeight;%add back the mean!
        end
    end
    
    
end
for i=1: length(VS)
    
    FLGdex=find(RivAlt.RivAlt.VSNUM==(i));
    

    if ~isempty(VS(i).AltDat) && ~isempty(VS(i).AltDat.c)&& length(VS(i).AltDat.c)>20;
        
        good=find(VS(i).AltDat.hbar>-9900);%no ice
        if isfield(VS(i).AltDat,'V3hbar')
        VS(i).AltDat.V3hbar(good)= VS(i).AltDat.V3hbar(good)
        else
             VS(i).AltDat.V3hbar(good)= VS(i).AltDat.hbar(good);%just use hbar if no changes
        end
%         if ~winsize.NavH
%             %
%             if ~isempty(FLGdex)
%                 flagout=find(RivAlt.RivAlt.flg(FLGdex) == -9995);%is from set good
%                 VS(i).AltDat.removeh=NaN(1,length(VS(i).AltDat.hbar))
%                 VS(i).AltDat.removeh(good(flagout))=VS(i).AltDat.hbar(good(flagout));
%                 VS(i).AltDat.hbar(good(flagout))=-9995;
%                 VS(i).AltDat.removet=NaN(1,length(VS(i).AltDat.hbar))
%                 VS(i).AltDat.removet(good(flagout))=VS(i).AltDat.t(good(flagout));
%                 VS(i).AltDat.t(good(flagout))=-9995;
%             end
%         end
    end
end


%split VS and save V3
[VSpack] = VSsorter(VS,loadswitch);

end
   
    

    




