function GradeUpdate(VS,grade,Toggle);
S=size(grade);
for i=1:S(1)
    if strfind(grade{i,1},VS(1).Satellite)
        Ez(i)= i;
    else
        Ez(i)= nan;
    end
end

G=~isnan(Ez);
Ez= Ez(G);
Jdata=grade(Ez,:);
%%open v2 grades and append to update freshly processed grades
gdir=dir(Toggle.Gradedir);
for j = 3:length(gdir)
    
    if ~isempty(strfind(gdir(j).name,VS(1).Satellite));
        ch=j;
    end
end
if ~exist('ch','var')
    sprintf(['There is no grade file for_',VS(1).Satellite])
    gradefile=[];
else
    gradefile=fullfile(Toggle.Gradedir,gdir(ch).name);
end
if ~isempty(gradefile)
[NUMj TXTj RAWj]=xlsread(gradefile,'A1:L800');
Sj = size(Jdata);
k=1;
 Jins ={};
 for i = 1:Sj(1)
     if ~contains(TXTj(:,1),Jdata(i,1))
         Jins(k,1:12)=Jdata(i,1:12);
         k=k+1;
     else
         for j = 1:length(TXTj);
             if strcmp(Jdata(i,1),TXTj(j,1));
                 RAWj(j,3:12)=Jdata(i,3:12);
             end
         end
     end
 end
RAWj=cat(1,RAWj,Jins);
OUTj={};
K=1;
for i=1:length(RAWj(:,1));
    if ~isnan(RAWj{i,1});
        OUTj(K,1:12)=RAWj(i,1:12);
        K=K+1;
    end
end
OUTj=sortrows(OUTj,1);
xlswrite(gradefile,OUTj);
else
end
end

