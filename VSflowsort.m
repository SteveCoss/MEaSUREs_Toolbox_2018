function [VS]=VSflowsort(VS);
[x,flowsort]=sort([VS.FLOW_Dist]);
VS=VS(flowsort);
keep=[VS.FLOW_Dist]>0;
VS=VS(keep);%Consider only VS with flowd
end
