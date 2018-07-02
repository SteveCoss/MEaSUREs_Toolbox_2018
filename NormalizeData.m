%normalize VS dad
function[RivAlt]= NormalizeData(RivAlt);
%% normalizte TS for hbar
%unique locations
for i= 1:length(RivAlt.RivLocations);
    if ~isempty(RivAlt.RivLocations(i).FLD);
        
        Hdex=find(RivAlt.RivAlt.X==RivAlt.RivLocations(i).FLD);
        if~isempty(Hdex)
            %hbar
            H=RivAlt.RivAlt.H(Hdex);
            maxnew=1;
            minnew=0;
            %percentiles
            PERC=prctile(H,[1:100]);
            [val LW]=min(abs(H-PERC(3)));
            [val Hgh]=min(abs(H-PERC(85)));
            maxold= max(H(Hgh));
            minold=min(H(LW));
            RivAlt.RivAlt.Hnorm(Hdex)=((maxnew-minnew)/ (maxold-minold))*(H-maxold)+maxnew ;%between set max and min
            %all h
            Hdex=find(RivAlt.RivAlt.Xh==RivAlt.RivLocations(i).FLD);
            H=RivAlt.RivAlt.Hh(Hdex);
            maxnew=1;
            minnew=0;
            %percentiles
            PERC=prctile(H,[1:100]);
            [val LW]=min(abs(H-PERC(3)));
            [val Hgh]=min(abs(H-PERC(85)));
            maxold= max(H(Hgh));
            minold=min(H(LW));
            RivAlt.RivAlt.Hhnorm(Hdex)=((maxnew-minnew)/ (maxold-minold))*(H-maxold)+maxnew ;%between set max and min
            
          

            
           
        end
    end
end
%% normalize cpnfidenc  interval values
H=RivAlt.RivAlt.H;
maxnew=1;
minnew=0;
%percentiles
PERC=prctile(H,[1:100]);
[val LW]=min(abs(H-PERC(3)));
[val Hgh]=min(abs(H-PERC(85)));
maxold= max(H(Hgh));
minold=min(H(LW));
MedianH=nanmedian(H);
anom=H-MedianH;
upavg=abs(mean(anom(find(anom>0))));
downavg=abs(mean(anom(find(anom<0))));

H(length(H)+1)=upavg;
H(length(H)+1)=downavg;
normdata=((maxnew-minnew)/ (maxold-minold))*(H-maxold)+maxnew; %between set max and min


RivAlt.CI(1)=normdata(end-1);
RivAlt.CI(2)=normdata(end);


return



