%densify time series
%written by Steve Coss,5.25.2016
function [VSpack] = SecondaryFilter(RunRiv,Toggle,Slist)

winsize.toggle='varying';%'manual'
winsize.manual=30;
winsize.multiplier=2.75;%2.5 was okay but didnt do much
winsize.NavH=true; %true to use pre average height
%% switches
loadswitch.Qfilter=false;
loadswitch.Qfilterthreshold =.6;
loadswitch.Smooth=true;
loadswitch.ChooseS=false;
loadswitch.SmoothS=1000;
loadswitch.GRRATSONY=false;
loadswitch.CLdir=Toggle.Centerlinedir;
loadswitch.VSdir=Toggle.VSdir;
loadswitch.SF=Toggle.SF;
loadswitch.SatList=Slist;
if Toggle.SF
%% loads up correct VSdata
[VS,CL]=VSloader_SF(RunRiv,loadswitch);%enviVS, JasonVS or merged VS
if ~isempty(VS) && ~isempty(CL);
[RivAlt]=allriverextractor(VS, loadswitch);
[RivAlt]=  NormalizeData(RivAlt);
WinSZ=0:0:length(RunRiv);
[RivAlt,WinSZ,SpG]=  FlagBad(RivAlt,winsize);
 [VSpack] = ALTERVS_SF(VS,RivAlt,winsize,loadswitch);
else
    VSpack = [];
 %% send out out the Curralt VS only
end
 if Toggle.OneAlt
     K=0
 for i = 1:length(Toggle.CurAlt)
     for j = 1:length(VSpack)
         if strfind(VSpack(j).VS(1).Satellite,Toggle.CurAlt{i})
             VSpackO(K+1).VS=VSpack(j).VS;
             K=K+1
         end
     end
 end
 if exist('VSpackO','var')
 VSpack=VSpackO;
 else
     VSpack=[];
     sprintf(strcat('The_',Toggle.CurAlt{1},'VS on the_',RunRiv,'_do not qualify for secondary filtering'))
 end
    
 end
else
    [VSpack,~]= VSloader_SF(RunRiv,loadswitch);
    if Toggle.OneAlt
     K=0
 for i = 1:length(Toggle.CurAlt)
     for j = 1:length(VSpack)
         if strfind(VSpack(j).VS(1).Satellite,Toggle.CurAlt{i})
             VSpackO(K+1).VS=VSpack(j).VS;
             K=K+1
         end
     end
 end
 if exist('VSpackO','var')
 VSpack=VSpackO;
 else
     VSpack=[];
     sprintf(strcat('The_',Toggle.CurAlt{1},'VS on the_',RunRiv,'_do not qualify for secondary filtering'))
 end
    
 end
end
end

