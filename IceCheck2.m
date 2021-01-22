%% Determine whether to use the IceFilter
% Written by S. Tuozzolo, 8/2014
% This can be updated in the future with more rivers... and maybe a better
% way for checking about ice. A latitude check?

function [DoIce,IceData] = IceCheck(rivername,Toggle);
        if strcmp(rivername,'Yukon') || strcmp(rivername,'Mackenzie')...
                ||strcmp(rivername,'Indigirka') || strcmp(rivername,'Kolyma')...
               || strcmp(rivername,'Lena') || strcmp(rivername,'Menzen')...
                ||strcmp(rivername,'Ob') || strcmp(rivername,'Olenyok')...
               || strcmp(rivername,'Pechora')|| strcmp(rivername,'StLawrence')...
               || strcmp(rivername,'Yenisei') || strcmp(rivername,'Kuloy')...
                || strcmp(rivername,'Pyasina') || strcmp(rivername,'Anadyr')...
                 || strcmp(rivername,'Khatanga') || strcmp(rivername,'Amur');
                
            DoIce=true;
        else
            DoIce=false;
        end
        icefile = fullfile(Toggle.Icedir,['icebreak_' rivername]);
        if DoIce
                    [IceData] = ReadIceFile2(icefile,Toggle.MODICE); %read in ice file for freeze/thaw dates
                else IceData=[];
        end
        if Toggle.IceCheck==0 %override ice removal
            DoIce=false;
            IceData=[];
        end
end