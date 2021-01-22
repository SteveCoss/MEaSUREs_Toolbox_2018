%run Chan's USGS reader here on the rivers in Toggle
function RUNgh(Toggle)
%identify relevant gages by river name
[NUM,TXT,RAW]=xlsread(fullfile(Toggle.USGSlistdir,'USGS_Selected_Site.xlsx'),1);
k=1;
for i = 1:length(Toggle.Curriv)
    for j = 1:length(TXT)
        if strcmp(Toggle.Curriv(i),cell2mat(TXT(j,6)))
            check(k)=j;
            k=k+1;
        end
    end
end
if exist('check','var');
CHKdb=RAW(check,:);
for i = 1:length(CHKdb)
    RIV=cell2mat(CHKdb(i,6));
    gh(strcat(num2str(cell2mat(CHKdb(i,1))),'.xml'),Toggle,RIV);
end
end
end