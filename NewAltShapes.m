%read in shapefile and change field names for new alt
clc; clear all; close all;
Newdir=0
ONEriv='Ayeyarwada'
INalt='Jason3'
INorbit='Jason'
INdr='C:\Users\coss.31\Documents\MATH\OSU_RA_Toolbox2018\INshapes'
RIVdir='C:\Users\coss.31\Documents\MATH\OSU_RA_Toolbox2018\INDB'
EULERdir='C:\Users\coss.31\Documents\MATH\EULER_OUT'
Rivers=load(fullfile(RIVdir,'Rivlist.mat'));
%rate!
RATE(1).N = 'Topex';
RATE(1).R = '10hz';
RATE(2).N = 'Jason1'; 
RATE(2).R='20hz';

if isempty(ONEriv)
R=Rivers.World;
else
    R={ONEriv};
end

for i=1:length(R)
    if strcmp(INorbit,'Jason')
        if isfile(fullfile(INdr,strcat(R{i},'_','Jason2V2.shp')));
        BaseFile=shaperead(fullfile(INdr,strcat(R{i},'_','Jason2V2.shp')))
        Ofile=BaseFile;
        for j=1:length(BaseFile)
            %id
            Ofile(j).Station_ID=strcat(R{i},'_',INalt,'_',num2str(BaseFile(j).Id));
            %rate
%             NRD=strfind([RATE.N],INalt);
%             NEWrate=RATE(NRD).R;
%             Ofile(j).rate= NEWrate;
        end
        if Newdir
           mkdir(EULERdir,strcat(R{i},'_',INalt))
            shapewrite(Ofile,fullfile(EULERdir,strcat(R{i},'_',INalt),strcat(R{i},'_',INalt,'.shp')));
        else
        shapewrite(Ofile,fullfile(INdr,strcat(R{i},'_',INalt,'.shp')));
        end
        %shapeinfo(fullfile(INdr,strcat(R{i},'_',INalt,'.shp')));
        end
    end
    if strcmp(INorbit,'Envisat')
        if isfile(fullfile(INdr,strcat(R{i},'_','EnvisatV2.shp')));
        BaseFile=shaperead(fullfile(INdr,strcat(R{i},'_','EnvisatV2.shp')))
        Ofile=BaseFile;
        for j=1:length(BaseFile)
            Ofile(j).Station_ID=strcat(R{i},'_',INalt,'_',num2str(BaseFile(j).Id));
        end
        shapewrite(Ofile,fullfile(INdr,strcat(R{i},'_',INalt,'.shp')));
        %shapeinfo(fullfile(INdr,strcat(R{i},'_',INalt,'.shp')));
        end
    end
end
