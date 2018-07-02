function [RunRiv,Satellite]=Optiontoggle(Toggle,Rivers,Satellite)
if Toggle.OneRiver
    RunRiv=Toggle.Curriv;
else
    RunRiv=Rivers.World;
end
if Toggle.OneAlt
   Satellite=Toggle.CurAlt;
else
    Satellite=Satellite.Satellite;
end
end