%RunRiverExtraction.m
%Written by S. Coss 6.8.2018
%The origional versions of this software were produced by M. Durand and
%S.Tuozzolo. This is the new primary operation script for the 2018 toolbox.
%This toolbox wilhave added functionality including secondary statistical
%filtering as well as storage calculation. The goal of this new edition is
%to remove the need for manual steps in future processing.
clear all ;close all; clc;
%% User toggles

Toggle.OneRiver=1;%set true to run only river named in toggle.Curriv
Toggle.Curriv={'Yukon'};
Toggle.OneAlt=0 ;%set true to look at just one altimiter or a subset
Toggle.CurAlt={'Jason1'};
Toggle.tide=1;%omit tidal stations
Toggle.validate=1;
Toggle.USGSpull=0;
Toggle.SF=1;%go through to secondary filtering and writing 
Toggle.Store=1;
Toggle.IceCheck=1;

%% This sections access several database documents to provide ...
%infastructure for futher processing.
TBroot='C:\Users\coss.31\Documents\MATH\OSU_RA_Toolbox2018\';
Rivers=load(fullfile(TBroot,'INDB','Rivlist.mat'));
Satellite=load(fullfile(TBroot,'INDB','SatList.mat'));
Toggle.Icedir=fullfile(TBroot,'INDB\Ice');
Toggle.Gradedir=fullfile(TBroot,'INDB\Grades');
Toggle.USGSlistdir=fullfile(TBroot,'INDB\USGS');
Toggle.RAdir=fullfile(TBroot,'INrawRA');
Toggle.Shapedir =fullfile(TBroot,'INshapes');
Toggle.Centerlinedir= fullfile(TBroot,'CenterLines');
Toggle.VSdir= fullfile(TBroot,'VSoutput');
Toggle.Validdir = fullfile(TBroot,'InValid');
Toggle.Statsdir = fullfile(TBroot,'StatsOut');
Toggle.FinalProductdir = fullfile(TBroot,'FinalProduct');
[Toggle.Tname,Toggle.Tdist]=tidereader;% pull tide distance
Toggle.MODICE=1;%use UCLA ice data when available
%% choose correct dadabse info to load beofre looping

[RunRiv,Satellite]=Optiontoggle(Toggle,Rivers, Satellite);

%% loop over every Vs on a river one Sat at a time

for iriv=1:length(RunRiv)
    Thisriv=RunRiv{iriv}
    if Toggle.validate% pull grades here only if not validating
        Grades =[];
    else
    [Grades]=gradelistreader2(Thisriv,Toggle,Satellite);%pull grade for river
    end
    [Toggle.DoIce,Toggle.IceData]=IceCheck2( Thisriv,Toggle); %check rivername to see if ice
    stations=0; 
    %% Loop through Altimiters on this river filter and build VS
    for isat = 1:length(Satellite)
        
        Thissat=Satellite{isat};
        [VS, Ncyc,S,stations] = ReadPotentialVirtualStations2(Thisriv,Thissat,stations,Toggle);
        if ~isempty(VS)
            DEM=zeros(length(stations),3);
            clear 'Gdat' %prevents errors from less Envi than J2stations
            for i = stations
                [VS(i).AltDat, DEM(VS(i).Id+1,:), Gdat(i)]= GetAltimetry2(VS(i),Ncyc,Toggle);
            end
            stations=Gdat+1;
            for i = 1 : length (stations)
                if stations(i)==0
                    VS(i).AltDat.Write = 0; % create write(negative) variable for bad VS before no longer processing them
                end
            end
            stations(stations==0)=[]; %remove stations from list with bad data
            if ~isempty(stations)
                [FilterData(isat).filter,FilterData(isat).Sat]=filtermaker(VS,DEM,stations);
           
            [VS] = PrimaryFilter(VS,S,stations,FilterData(isat).filter,Toggle,Thisriv);
          if ~Toggle.SF
            VSpuller2(VS,Thisriv,Thissat);%saves the VS for each sat/riv combo
          end
            
            end
        end
    end
    %% Combine ALL VS for river for second filter
   
    [VSpack] = SecondaryFilter(Thisriv,Toggle,Satellite);
    %% Grades and validation
    [VSpack] = gradecheck2(VSpack,Grades,Toggle,Thisriv,Satellite);
    %% Write to .nc and generate run report
    if ~isempty(VSpack)&& ~isempty(Toggle)&& ~isempty(FilterData)
    RiverWriter(VSpack,Toggle,FilterData);
    else
        sprintf(strcat('There were no files to write for_',Thissat,'_on the_',Thisriv,'_river'))
    end
    
    
    
end