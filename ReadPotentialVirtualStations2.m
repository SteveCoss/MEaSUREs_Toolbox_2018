function [VS,Ncyc,S,stations] = ReadPotentialVirtualStations2(fname,satellite,stations,Toggle)
Riv=fname;
fnameshape=fullfile(Toggle.Shapedir,[fname '_' satellite 'V2']);
INdirRA=dir(fullfile(Toggle.RAdir));
for i = 3: length(INdirRA)
    if~isempty(strfind(INdirRA(i).name,strcat(fname,'_',satellite)));
        filecheck =1;
    end
end
if ~exist('filecheck','var') || isempty(filecheck)
    filecheck =-1;
end
%%verify file present
if filecheck==-1
    VS=[];
    Ncyc=[];
    S=[];
else
    %%create VS using shape file
    [S,SMF]=Shapeselector(satellite,fnameshape,Toggle,fname);
    
    VS =struct();
    for i=1:length(S);
        if ~isempty(SMF);
            [VS] =shapereindexer(S,SMF,VS,i,Riv);
        end
        [VS]=VSpackager(VS,S(i),satellite,i,SMF);
        [VS,Ncyc] = Cycle_Rate(VS,satellite,i);
        
        
    end
    
        stations=1:length(VS);
     %run all stations unless otherwise specified
    %sometimes the stations are in VS structure out of order due to the order
    %they were origionally drawn in they must be sorted by id.
    if length(VS)>1
        [sx,sx]=sort([VS.Id]);
        ss=VS(sx);
        VS=ss;
    end
    
end