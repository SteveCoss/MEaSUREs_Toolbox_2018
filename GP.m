function [VS] = GP(VS,Grades)
if ~isempty(Grades)
    G={Grades.grades};
    Grades=(Grades(find(~cellfun(@isempty,G))));
    gdex=find(strcmp([Grades.Sat],VS(1).Satellite)==1);
    
    if ~isempty(gdex) && ~isempty(Grades(gdex).grades)
        gradecells=string([Grades(gdex).grades.name]);
        for j = 1:length(VS)
            for k =1:length(gradecells)
                dex(j,k)=strcmp(VS(j).ID,gradecells(k));
            end
            if sum(dex(j,:))>0
                VS(j).grade=Grades(gdex).grades(find(dex(j,:)==1)).grade;
                VS(j).stats=Grades(gdex).grades(find(dex(j,:)==1)).stats;
            else
                VS(j).grade = 'z';
                VS(j).stats = 'z';
            end
        end
    else
        for j = 1:length(VS)
            VS(j).grade = 'z';
            VS(j).stats = 'z';
        end
    end
else
    for j = 1:length(VS)
        VS(j).grade = 'z';
        VS(j).stats = 'z';
    end
end