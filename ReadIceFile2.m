function [IceData] = ReadIceFile2(fname)
[d f] =xlsread(fname);
thaw=datenum(f(:,1));
freeze=datenum(f(:,2));

IceData(:,1)=str2num(datestr(thaw,10));
    IceData(:,2)=thaw;
    IceData(:,3)=freeze;
return