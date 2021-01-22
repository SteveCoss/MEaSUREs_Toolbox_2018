function [Gout] = ADDfd2gage(Gin,Riv,ST,svnm);
CL=shaperead(fullfile('C:\Users\coss.31\Documents\MATH\OSU_RA_Toolbox2018\CenterLines',strcat(Riv,'_centerline.shp')));
%unpack CL
Xline = [CL.X];
Yline = [CL.Y];
Xg=Gin.Lon;Yg=Gin.Lat;
FD = CL.Flow_Dist;
%reproject center;ine
ZONE = utmzone(Yline, Xline);
mstruct = defaultm('utm');
mstruct.zone = ZONE;
mstruct.geoid = almanac('earth','wgs84','meters');
mstruct = defaultm(mstruct);
[Xline,Yline]=mfwdtran(mstruct,Yline,Xline);
Xline = smooth(Xline);
Yline = smooth (Yline);
[Xg,Yg]=mfwdtran(mstruct,Yg,Xg);
 [blork DX]= min(abs(sqrt((  Xg-Xline).^2 + ( Yg-  Yline).^2 )));
 Gout=Gin;
 Gout.GageFLdist=CL(DX).Flow_Dist;
  Gout.RIVER=Riv;
  Cut1=ST(length(Riv)+1:end);
  Cut2=Cut1(1:end-6);
  Gout.Station=Cut2;
  DATE=Gout.DATE;
  Lat=Gout.Lat;
  Lon=Gout.Lon;
  stage=Gout.stage;
  GageFLdist=Gout.GageFLdist;
  RIVER=Gout.RIVER;
  Station=Gout.Station;
  if isfield(Gout,'flags')
  flags=Gout.flags;
  ice=Gout.ice;
  save(svnm,'DATE','Lat','Lon','flags','ice','stage','GageFLdist','RIVER','Station');
  else
      save(svnm,'DATE','Lat','Lon','stage','GageFLdist','RIVER','Station');
  end
  
end