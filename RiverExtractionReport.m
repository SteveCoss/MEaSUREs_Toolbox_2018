function  RiverExtractionReport(VS,Toggle);
looking=1;
while looking
    for i = 1:length(VS)
        if ~isempty(VS(i).VS);
            looking=0;
            Nempty=i;
        end
    end
end

R={VS(Nempty).VS.Riv};
Riv=unique(R(find(~cellfun(@isempty,R))));
filename=[Riv{1} '_Runreport.txt'];
FID = fopen(fullfile(Toggle.FinalProductdir,'Reports',filename),'wt');
%datestamp\header
fprintf(FID,'%s',Riv{1},'_run report');
T=clock;
Tstamp =strcat('date_created_', datestr(T));
fprintf(FID,'\r%s',Tstamp);

for i = 1: length(VS)
%% loop through current VS to determine which 
 CurVS=VS(i).VS;
 clear Tag
 if ~isempty(CurVS)
 for j = 1:length(CurVS)
     
     if CurVS(j).AltDat.Write
         if ~strcmp(CurVS(j).grade,'z') || isstruct(CurVS(j).stats)
             Tag(j)=1;%this VS is complete
         else
             Tag(j)=2;%These are good VS that need validation
         end
     else
         Tag(j)=0;
     end
     
 end
completeDX = find(Tag == 1);
NeedValidDX = find(Tag == 2);
BadvsDX = find(Tag ==0);
A1 = max([CurVS.Id])+1; %VS at this stage do not include those rejected by Tide filter this gets number right
A2 = length(completeDX);
fprintf(FID,strcat('\r%d Virtual Stations identified for_', CurVS(1).Satellite,'_%d written to NetCDF'),A1,A2);
%written/finished
for j = 1:length(completeDX)
fprintf(FID,'\r%s,', CurVS(completeDX(j)).ID);
end
%need grades
if ~isempty(NeedValidDX)
fprintf(FID,'\r%s','The following VS are suitible for writing but require QA/QC');
for j = 1:length(NeedValidDX)
fprintf(FID,'\r%s,', CurVS(NeedValidDX(j)).ID);
end
%screen print warning for user to validate
sprintf('Some VS that are of sucificient quality for writing require validation.')
sprintf(strcat('Check the_',Riv{1}, 'report file for details.' ))
end
end
end
fclose(FID);
end