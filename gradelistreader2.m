%gradelistreader
%process grades and store for use in the loop
function [Grades]=gradelistreader(Riv,Toggle,Satellite)
if Toggle.OneAlt
    CheckSat=Toggle.CurAlt;
else
    CheckSat=Satellite;
end
for i=1:length(CheckSat)
    
    gdir=dir(Toggle.Gradedir);
    for j = 3:length(gdir)
       
        if ~isempty(strfind(gdir(j).name,CheckSat{i}));
            ch=j;
        end
    end
    if ~exist('ch','var')
        sprintf(['There is no grade file for_',CheckSat{i}]);
         gradefile=[];
    else
        gradefile=fullfile(Toggle.Gradedir,gdir(ch).name);
    end
    if ~isempty(gradefile)
    [~,~,RAW]=xlsread((gradefile),'','','');
    
    S=size(RAW);
    k=0;
    clear Store
    for j=1:S(1)
        
        Currgrades(j).name=RAW((j),1);
        if isempty(RAW{(j),2})
            Currgrades(j).grade=nan;
        else
            Currgrades(j).grade=RAW{(j),2};
        end
        if S(2)>2
            Currgrades(j).stats.nse=RAW{(j),3};
            Currgrades(j).stats.nsemedian=RAW{(j),4};
            Currgrades(j).stats.R=RAW{(j),5};
            Currgrades(j).stats.std=RAW{(j),6};
            Currgrades(j).stats.stdmedian=RAW{(j),7};
            %prox
            if S(2)>7
            Currgrades(j).stats.prox=RAW{(j),9};
            Currgrades(j).stats.proxSTD=RAW{(j),10};
            Currgrades(j).stats.proxR=RAW{(j),11};
            Currgrades(j).stats.proxE=RAW{(j),12};
            end
             if S(2)>12
            Currgrades(j).stats.Rst=RAW{(j),13};
            Currgrades(j).stats.nsest=RAW{(j),14};
            Currgrades(j).stats.nsemedianst=RAW{(j),15};
            Currgrades(j).stats.stdst=RAW{(j),16};
            Currgrades(j).stats.stdmedianst=RAW{(j),17};
            end
        else
            Currgrades(j).stats =[];
        end
        nmstr=cell2mat(Currgrades(j).name);
       
        if length(nmstr)> length(Riv) && strcmp(nmstr(1:length(Riv)),Riv);
            k=k+1;
            Store(k)=Currgrades(j);
        end
        
        
    end
    
    if exist('Store','var')
        Grades(i).grades=Store;
    else
        Grades(i).grades=[];
    end
    Grades(i).Sat=CheckSat(i);
    else
        Grades=[];
    end
    
end


