%tide reader
%process tide distance and store for use in the loop
function [Tname,Tdist]=gradelistreader(sat)
%envi
tidefile=fullfile('C:\Users\coss.31\Documents\MATH\OSU_RA_Toolbox2018\INDB','Tidal_list.xlsx');
[NUM,TXT,RAW]=xlsread((tidefile));
Tname=RAW(:,1);
Tdist=RAW(:,2);


return