%VSloader
%sub function for loading selected VS files
function [VS,CL]=VSloader(RunRiv,loadswitch)
%load all VS contaning strin runriv
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
        for i = 1:length(ch)
            VSdata(i)=load(fullfile(loadswitch.VSdir,VSdir(ch(i)).name));
        end
    end
%% sort /quality filter
for i = 1:length(VSdata);
%sort
[VSdata(i).VS]=VSflowsort(VSdata(i).VS);

%qfilter
if loadswitch.Qfilter
[VSdata(i).VS]=Qfilter(VSdata(i).VS,loadswitch);
end
%meansurface
[VSdata(i).VS] =Meansurface_SF(VSdata(i).VS);
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
end