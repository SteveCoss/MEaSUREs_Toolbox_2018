%VSloader
%sub function for loading selected VS files
function [VS,CL]=VSloader(RunRiv,loadswitch)
%load all VS contaning strin runriv
STL=loadswitch.SatList;
VSdir=dir(loadswitch.VSdir);
k=1;
for j = 3:length(VSdir)
    if ~isempty(strfind(VSdir(j).name,RunRiv));
        if ~strcmp(VSdir(j).name(end-6:end),'_SF.mat')%exclude secondary filterVS
            ch(k)=j;
            k=k+1;
        end
    end
end
if ~exist('ch','var')|| isempty(ch)
    sprintf(['There are no VS files for_',RunRiv]);
    VSdata=[];
else
    %load in loadswitch.satlist order
    for SO = 1:length(STL)
        clear NcHF
        for SOSO=1:length(ch);
            if ~isempty(strfind(VSdir(ch(SOSO)).name,STL{SO}))
                Nch(SO)=ch(SOSO);
                NcHF=1;
            end
        end
        if ~exist('NcHF','var')
            Nch(SO)=nan;
        end
    end
    ch=Nch;
    
    for i = 1:length(ch)
        if ~isnan(ch(i))
            VSdata(i)=load(fullfile(loadswitch.VSdir,VSdir(ch(i)).name));       
        end
        if length(ch)==1 && isnan(ch)
            VSdata=[];
        end
        
    end
end
    if loadswitch.SF
%% sort /quality filter
for i = 1:length(VSdata);
    if ~isempty(VSdata(i).VS)
%sort
[VSdata(i).VS]=VSflowsort(VSdata(i).VS);

%qfilter
if loadswitch.Qfilter
[VSdata(i).VS]=Qfilter(VSdata(i).VS,loadswitch);
end
%meansurface
[VSdata(i).VS] =Meansurface_SF(VSdata(i).VS);
    end
end

%% combine
VSall=[];
for i = 1:length(VSdata);
if ~isempty(VSdata(i).VS) 
    VSall=[VSall VSdata(i).VS];
end
end
%sort combined
if ~isempty(VSall)
[VS]=VSflowsort(VSall);
CLfile = (fullfile(loadswitch.CLdir,strcat(RunRiv,'_centerline')));
CL=shaperead(CLfile);
else 
    VS =[];
    CL = [];
end
    else
        VS=VSdata;
        CL=[];
    end
end