%CBelevations-Function
%This function is designed to constreign baseline elevations based on
%maintaining a down hill gradiend in the the down flow direction.
%origional code developed by Mike Durand
%Adaptation into an altimetry toolbox function by Steve Coss

function [FilterData] = CBelevations(VS,FilterData)
%% sort the x data s.t. the x- is increasing

for i=1:length(FilterData);
    if ~isempty(FilterData(i).ID) && ~isnan(FilterData(i).AbsHeight)
FD(i)=VS(i).FLOW_Dist;
hbaseRaw(i)=FilterData(i).AbsHeight;
    else
FD(i)=nan;
hbaseRaw(i)=nan;
    end
    
end
FDdex=~isnan(FD);
FD=FD(FDdex);
hbasedex=~isnan(hbaseRaw);
hbaseRaw=hbaseRaw(hbasedex);
if ~isempty(hbaseRaw)
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
FilterDatagood=FilterData(FDdex);
for i= 1:length(FilterDatagood)
  
        FilterDatagood(iorder(i)).AbsHeight=hc(i);
        FilterDatagood(iorder(i)).MaxFlood=hc(i)+15;
        FilterDatagood(iorder(i)).MinFlood=hc(i)-10;
   
end
FilterData(FDdex)=FilterDatagood;
else
FilterData=[];    
    
    
end

return 