function [VS]=VSpackager(VS,S,satellite,i,SMF)
VS(i).Lat=nanmean(S.Y);
if isempty(SMF)
VS(i).ID=S.Station_ID;
end
VS(i).Lon=nanmean(S.X);
VS(i).Width=S.RivWidth;
VS(i).Pass=S.Pass_Num;
ID=strsplit(VS(i).ID,'_');
VS(i).Id=str2num(cell2mat(ID(3)));
if ~isempty(S.Landsat_ID);
    VS(i).LSID=S.Landsat_ID;
else
    VS(i).LSID='NA';
end
VS(i).Satellite=satellite;
VS(i).X=S.X;
VS(i).Y=S.Y;
VS(i).FLOW_Dist=S.Flow_Dist;

if isfield(S,'Island_Flg')
    
    VS(i).Island=S.Island_Flg;
else
    VS(i).Island=-1;
end
C = strsplit(VS(i).ID,'_');
VS(i).Riv=C{1};
end