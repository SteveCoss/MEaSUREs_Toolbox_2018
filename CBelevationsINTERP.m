%CBelevations-Function
%This function is designed to constreign baseline elevations based on
%maintaining a down hill gradiend in the the down flow direction.
%origional code developed by Mike Durand
%Adaptation into an altimetry toolbox function by Steve Coss

function [RivLocations] = CBelevationsINTERP(RivLocations)
%% sort the x data s.t. the x- is increasing

for i=1:length(RivLocations);
    if ~isempty(RivLocations(i).FLD) && ~isnan(RivLocations(i).BLH);
FD(i)=RivLocations(i).FLD;% this is the flow distance
hbaseRaw(i)=RivLocations(i).BLH; %this is the heights you want constrained
    else
FD(i)=nan;
hbaseRaw(i)=nan;
    end
    
end
FDdex=~isnan(FD);
FD=FD(FDdex);
hbasedex=~isnan(hbaseRaw);
hbaseRaw=hbaseRaw(hbasedex);
[x,iorder]=sort(FD,'ascend');
hbase=hbaseRaw(iorder);


%% L1-lp
n=length(FD);
c=[zeros(n,1); ones(n,1);];
F=zeros(n-1,n);
F(1:n-1,1:n-1)=F(1:n-1,1:n-1)+eye(n-1);
F(1:n-1,2:n)=F(1:n-1,2:n)-eye(n-1);
A=[eye(n) -eye(n);
   -eye(n) -eye(n);
   F       zeros(n-1,n);];
b=[hbase';
  -hbase';
  zeros(n-1,1);];

yc=linprog(c,A,b);
hc=yc(1:n);
%% Take this output and replace AbsHeight
Datagood=RivLocations(FDdex);
for i= 1:length(Datagood)
  
      Datagood(iorder(i)).BLH=hc(i);
      
   
end
RivLocations(FDdex)=Datagood;
    
    


return 