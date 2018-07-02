function RiverWriter(VS,Toggle,FilterData);
if ~isempty(VS)
Fsats={FilterData.Sat};
for i = 1: length(VS)
   for j = 1:length(Fsats)
       if strcmp(Fsats{j},VS(i).VS(1).Satellite)
           FDin= FilterData(j);
       end
   end
    WriteAltimetryData2(VS(i).VS,FDin.filter,Toggle)
end
 %have a report for each river
    RiverExtractionReport(VS,Toggle)
else
    %sprintf(strcat('There are no viable VS for the','_',
end
end