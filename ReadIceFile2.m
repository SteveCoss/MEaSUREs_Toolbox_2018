function [IceData] = ReadIceFile2(fname,MODICE)
[d f] =xlsread(fname);
S=size(f);
if MODICE && S(2)==4
    for i = 1:length(f)
        if ~isempty(f{i,3})
            thaw(i)=datenum(f(i,3));
        else
            thaw(i)=datenum(f(i,1));
        end
         if ~isempty(f{i,4})
            freeze(i)=datenum(f(i,4));
        else
            freeze(i)=datenum(f(i,2));
        end
    end
else
thaw=datenum(f(:,1));
freeze=datenum(f(:,2));
end

IceData(:,1)=str2num(datestr(thaw,10));
    IceData(:,2)=thaw;
    IceData(:,3)=freeze;
return