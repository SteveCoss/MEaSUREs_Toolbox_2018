function RiverWriter(VS,Toggle,FilterData);
if ~isempty(VS)
Fsats={FilterData.Sat};
for i = 1: length(VS)
   for j = 1:length(Fsats)
       if ~isempty(VS(i).VS)
       if strcmp(Fsats{j},VS(i).VS(1).Satellite)
           FDin= FilterData(j);
       else if j==max(j) & ~exist('FDin','var');
            FDin=[];
           end
       end
       else
            FDin=[];
       end
   end
   if ~isempty(FDin)&& Toggle.SF %doesn't write if no SF
    WriteAltimetryData2(VS(i).VS,FDin.filter,Toggle)
   end
end
 %have a report for each river
    RiverExtractionReport(VS,Toggle)
else
    %sprintf(strcat('There are no viable VS for the','_',
end
end