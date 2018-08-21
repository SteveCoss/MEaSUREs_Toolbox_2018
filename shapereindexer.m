function   [VS] =shapereindexer(S,SMF,VS,i,Riv)

if strcmp(SMF,'Topex')
    Key   = [Riv '_' 'Jason2_'];
    Index = strfind(S(i).Station_ID, Key);
    Value = sscanf(S(i).Station_ID(Index(1) + length(Key):end), '%g', 1);
    VS(i).ID=[Riv '_' SMF '_' num2str(Value)];
else if strcmp(SMF,'ERS1c')
        Key   = [Riv '_' 'Envisat_'];
        Index = strfind(S(i).Station_ID, Key);
        Value = sscanf(S(i).Station_ID(Index(1) + length(Key):end), '%g', 1);
        VS(i).ID=[Riv '_' SMF '_' num2str(Value)];
    else if strcmp(SMF,'ERS1g')
            Key   = [Riv '_' 'Envisat_'];
            Index = strfind(S(i).Station_ID, Key);
            Value = sscanf(S(i).Station_ID(Index(1) + length(Key):end), '%g', 1);
            VS(i).ID=[Riv '_' SMF '_' num2str(Value)];
        else if strcmp(SMF,'SARAL')
                Key   = [Riv '_' 'Envisat_'];
                Index = strfind(S(i).Station_ID, Key);
                Value = sscanf(S(i).Station_ID(Index(1) + length(Key):end), '%g', 1);
                VS(i).ID=[Riv '_' SMF '_' num2str(Value)];
            end
        end
    end
end
end