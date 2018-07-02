%how validated are we ?
%aggrigate river
function whofeelsvalidated_GC(VS,Toggle)
RIV={VS.Riv};
Riv=unique(RIV(find(~cellfun(@isempty,RIV))));
River=Riv{1};
flist=dir(fullfile(Toggle.Statsdir,strcat(River,'*.mat')));
for ii=1:length(flist)
    data{ii}=load(fullfile(Toggle.Statsdir,flist(ii).name)); % load files in workspace
end
%put stuff in vectors for ploting
if exist('data','var');
s=size(data);
for i=1:s(2);
    s2=size(data{1,i}.Stats);
    for j=1:s2(2);
        if ~isempty(data{1,i}.Stats(j).STD);
            
            ID(j,i)={data{1,i}.Stats(j).ID};
            
            rawE(j,i)=data{1,i}.Stats(j).E;
            rawSTD(j,i)=data{1,i}.Stats(j).STD;
            rawwidth(j,i)=data{1,i}.Stats(j).Width;
            gratio(j,i)=data{1,i}.Stats(j).precentgood;
            R(j,i)=data{1,i}.Stats(j).R;
            id(j,i)=data{1,i}.Stats(j).Id;
            PROX(j,i)=data{1,i}.Stats(j).proximity;
        end
    end
end
%this reshapes into one vector
SS=size(ID);
alls=SS(1)*SS(2);

ID=reshape(ID,alls,1);

rawE=reshape(rawE,alls,1);
rawSTD=reshape(rawSTD,alls,1);
rawwith=reshape(rawwidth,alls,1);
gratio=reshape(gratio,alls,1);
R=reshape(R,alls,1);
PROX=reshape(PROX,alls,1);
id= reshape(id,alls,1);
%this removes all the blanks
for i =1:length(ID)
    if ~isempty(ID{i});
        IDdex(i)=1;
    else IDdex(i)=0;
    end
end
IDdex=find(IDdex==1);
ID=ID(IDdex);

totalchecked=unique(ID);

rawE=rawE(IDdex);
rawSTD=rawSTD(IDdex);
rawwidth=rawwidth(IDdex);
gratio=gratio(IDdex);
R=R(IDdex);
PROX=PROX(IDdex);
id=id(IDdex);

%meta validation
%this pulls out all values for unique VS an in some cases finds an average
for i=1:length(ID)
    if ~isempty(ID(i))
        stationdex=find(strcmp(ID(i),ID));
        
        stationmaxE(i)=max(rawE(stationdex));
        stationaverageE(i)=nanmean(rawE(stationdex));
        
        stationminSTD(i)=min(rawSTD(stationdex));
        stationaverageSTD(i)=nanmean(rawSTD(stationdex));
        stationwidth(i)=min(rawwidth(stationdex));
        stgratio(i)=min(gratio(stationdex));
        stRmax(i)=max(R(stationdex));
        stRavg(i)=mean(R(stationdex));
        idid(i)=id(stationdex(1));
        %prox
        [stMinprox(i) minproxdex]=min(abs(PROX(stationdex)));
        stMinproxSTD(i)=rawSTD(stationdex(minproxdex));
        stMinproxR(i)=R(stationdex(minproxdex));
        stMinproxE(i)=rawE(stationdex(minproxdex));
      
        
    end
end
%removes redundant values an creats final 1:1 stat for each VS
for i=1:length(totalchecked)
    stdex=find(strcmp(totalchecked(i),ID),1);
    mxE(i)=stationmaxE(stdex);
    avgE(i)=stationaverageE(stdex);
    minSTD(i)=stationminSTD(stdex);
    avgSTD(i)=stationaverageSTD(stdex);
    wide(i)=stationwidth(stdex);
    gratiost(i)=stgratio(stdex);
    Rstmax(i)=stRmax(stdex);
    Rstavg(i)=stRavg(stdex);
    ididid(i)=idid(stdex);
    
     Minprox(i)=stMinprox(stdex);
    MinproxSTD(i)=stMinproxSTD(stdex);
    MinproxR(i)=stMinproxR(stdex);
    MinproxE(i)=stMinproxE(stdex);
   
end
medMXE=nanmedian(mxE);
p=mxE>0;
mxEGR0=length(mxE(p))/length(mxE);
medSTD=nanmedian(minSTD);
medRmax=nanmedian(Rstmax);
medRavg=nanmedian(Rstavg);
posmxE=mxE>0;
posmnE=avgE>0;

grade=totalchecked;
grade(:,5)=num2cell(Rstmax);
grade(:,3)=num2cell(mxE);
grade(:,4)=num2cell(avgE);
grade(:,6)=num2cell(minSTD);
grade(:,7)=num2cell(avgSTD);
grade(:,8)=num2cell(ididid);

grade(:,9)=num2cell( Minprox);
grade(:,10)=num2cell(MinproxSTD);
grade(:,11)=num2cell(MinproxR);
grade(:,12)=num2cell(MinproxE);

%splin into alt sets and generate xls for processvirtualstations.m to read
GradeUpdate(VS,grade,Toggle);
end
end






