function [FilterData,Sat]=filtermaker(VS,DEM,stations);
FilterData=struct([]);
FilterData=CreateFilterData2(VS,DEM,FilterData,stations);
[FilterData]=CBelevations2(VS,FilterData);%constreign by baseline elevation
Sat= VS(1).Satellite;
%use fill value for empty filter slots
for i = 1:length(FilterData);
    if isempty(FilterData(i).ID);
        FilterData(i).ID=nan;
    end
end
end