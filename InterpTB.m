%% first crack at interp
% created By Mike Durand
% Last edited by Steve Coss 11/30/2015
clear all; close all; clc

%%user input section
doplot=true% true to create plots
CDZ=false % just use version 3!!
sat=3%1=J2 2=Envi 3=both
seperate=true %true to interpolate altimiters seperatly then merge
%%  list of rivers available
NorthAmerica={'Columbia','Mackenzie','StLawrence','Susquehanna', 'Yukon','Mississippi'};
SouthAmerica={'Amazon','Orinoco','Tocantins','SaoFrancisco','Uruguay','Magdalena','Parana','Oiapoque','Essequibo','Courantyne'};
Africa={'Congo','Nile','Niger','Zambezi'};
Eurasia={'Amur','Anabar','Ayeyarwada','Kuloy','Ob','Mezen','Lena','Yenisei','Pechora','Pyasina','Khatanga','Olenyok' ...
    ,'Kolyma','Anadyr','Yangtze','Mekong','Ganges','Brahmaputra','Indus','Volga'};
WORLD = [NorthAmerica SouthAmerica Africa Eurasia];
CurrRiv={'SaoFrancisco'}; %put selected river here in string form

RunRiv=CurrRiv;%you can switch this to CurrRiv if you only want to run one river.
%% is there a gage for this tiver
NoGage=true
%% enter gage file info for ploting
FnAmE='Amazon15040000'%the gague file for comparison
gaguefile=fullfile('C:\Users\coss.31\Documents\Work\Rivers\Validation data\VALIDMAT\V2flowd',FnAmE)%gague directory

%% switches
loadswitch.offsetswitch=false %address altimiter offset
loadswitch.MSswitch=true%remove individual TS means then add baseline back
loadswitch.Steveterp=false
loadswitch.scatteredinterpolant=true;%use scattered interpolant instead of griddata
loadswitch.version=3 %uses different VS verson
loadswitch.Qfilter=false;
loadswitch.Qfilterthreshold =.6;
loadswitch.Smooth=true;
loadswitch.ChooseS=false
loadswitch.SmoothS=1000;
loadswitch.GRRATSONY=true;
loadswitch.fdh=true %FORCE FINAL PRODUCT TO GO DOWNHILL
%% loads up correct VS and gague data
GF=load(gaguefile);%gague data
[VSe,VSj,VS,CL]=VSloader(RunRiv,sat,loadswitch);%enviVS, JasonVS or merged VS
%% extracts relevant data for processing
[RivAlt]=allriverextractor(VS, loadswitch);
%% condense and remove
if CDZ
[RivAlt]=  NormalizeData(RivAlt);
figure;
scatter(RivAlt.RivAlt.Y,RivAlt.RivAlt.Hnorm,'.');
[RivAlt]=  FlagBad(RivAlt);
Good=RivAlt.RivAlt.Hnorm>-9998;
hold on

scatter(RivAlt.RivAlt.Y(Good),RivAlt.RivAlt.Hnorm(Good),'.');


RivAlt.RivAlt.H=RivAlt.RivAlt.H(Good);
RivAlt.RivAlt.X=RivAlt.RivAlt.X(Good);
RivAlt.RivAlt.Y=RivAlt.RivAlt.Y(Good);

end

%% interpolate extracted data
[TERP,x,y,s]=riverinterpolater(RivAlt,VSe,VSj,seperate,sat,loadswitch,CL);
%% save the interpolation for later use
TERPsaver(TERP,RunRiv,sat,x,y,s);
%% plot data
if doplot
    TERPdataPLOTTER(TERP, x,y,GF,s,RunRiv,NoGage);
end