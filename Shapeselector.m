function [S,SMF] = Shapeselector(satellite,fnameshape,Toggle,fname);



if strcmp(satellite,'Envisat')||strcmp(satellite,'Jason2') ||strcmp(satellite,'Jason1') ||strcmp(satellite,'Topex') ||strcmp(satellite,'Jason3')
    if ~strcmp(satellite,'Jason1')&& ~strcmp(satellite,'Topex')&& ~strcmp(satellite,'Jason3')
        S=shaperead(fnameshape);
    else if strcmp(satellite,'Jason1')
        S=shaperead(fullfile(Toggle.Shapedir,[fname '_' 'Jason1']))
        else if strcmp(satellite,'Topex')
            S=shaperead(fullfile(Toggle.Shapedir,[fname '_' 'Topex']))
            else
                  S=shaperead(fullfile(Toggle.Shapedir,[fname '_' 'Jason3']))
            end
                
        end
    end
    SMF=[];%shapemodflag
else if strcmp(satellite,'TopexPos')
        S=shaperead(fullfile(Toggle.Shapedir,[fname '_' 'Jason2' 'V2']));%need to pull in and modify J2 shape because thee are no Topex shapes
        SMF= satellite;%shapemodflag
    else if strcmp(satellite,'ERS1c')||strcmp(satellite,'ERS1g') ||strcmp(satellite,'ERS2')
            S=shaperead(fullfile(Toggle.Shapedir,[fname '_' 'Envisat' 'V2']));
            SMF= satellite;%shapemodflag
        else if strcmp(satellite,'SARAL')
                S=shaperead(fullfile(Toggle.Shapedir,[fname '_' 'Envisat' 'V2']));%need to pull in and modifyEnvi
                SMF= satellite;%shapemodflag
            end
        end
    end
end
end