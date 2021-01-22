%tide check
function VS =gradecheck(VS,riv,Tname, Tdist)

%% take tide distances that are relivant from the sheet

index=strfind(Tname,riv);
dx=find(~cellfun(@isempty,index));
distkm=Tdist{dx};
dist=distkm;%no longer in km
if VS.FLOW_Dist<dist;
    VS.AltDat.Write=0;
     VS.AltDat.TideFail=1;
end
return