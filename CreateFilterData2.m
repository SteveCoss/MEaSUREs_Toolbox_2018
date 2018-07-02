%% This program creates the initial filter boundaries
%Written 8/2015 by Steve Tuozzolo
%altered on 2.5.2018 to check DEM existence with isnan rather than >0

function FilterData=CreateFilterData(VS,DEM,FilterData,stations);

for i=stations
        FilterData(i).ID=VS(i).Id;
        FilterData(i).Sat=VS(i).Satellite;
        DEMt=DEM(FilterData(i).ID+1,:);
    if ~isnan(DEMt(1)) %check for SRTM data
        FilterData(i).AbsHeight=DEMt(1); %use SRTM data 1st
        FilterData(i).AvgGradient=VS(i).AltDat.AvgGradient(1);
        FilterData(i).DEMused='SRTM';
    else if ~isnan(DEMt(3)) %check for GTOPO30/GMTED2010 data
            FilterData(i).AbsHeight=DEMt(3); %use this data second
            FilterData(i).AvgGradient=VS(i).AltDat.AvgGradient(2);
            FilterData(i).DEMused='GTOPO30/GMTED2010';
        else if ~isnan(DEMt(2))
                FilterData(i).AbsHeight=DEMt(2); %ASTER data used.
                FilterData(i).AvgGradient=VS(i).AltDat.AvgGradient(2);
                FilterData(i).DEMused='ASTER';
            else
                if i>1
                    FilterData(i).AbsHeight= nan; % if all are NaN, assume height=previous height
                     FilterData(i).DEMused='None';
                else
                    FilterData(i).AbsHeight=0;
                     FilterData(i).DEMused='None';
                end
                FilterData(i).AvgGradient=0;
            end
        end
    end
    
    if isempty(FilterData(i).AbsHeight)
        if ~isempty(FilterData(i).AbsHeight)
            FilterData(i).AbsHeight=FilterData(i-1).AbsHeight;
        else
            FilterData(i).AbsHeight=0;
        end
    end
    
    FilterData(i).MaxFlood=FilterData(i).AbsHeight+15; %set upper bound of flood - 15m
    FilterData(i).MinFlood=FilterData(i).AbsHeight-10; %set lower bound of low flow - 10m
end
end