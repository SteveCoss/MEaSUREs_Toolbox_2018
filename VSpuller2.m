%VSpuller
%Written by Steve Coss
%extracts and names VS structures from process virtual station runs and
%saves them for interpilation processing.
function VSpuller2(VS, rivername,satellite)
if ~isempty(VS)
NAME=strcat(rivername,satellite,'VS');
File=fullfile('C:\Users\coss.31\Documents\MATH\OSU_RA_Toolbox2018\VSoutput',NAME);
save(File,'VS');
end
end