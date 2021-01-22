%gradecheck
function [VS] =gradecheck(VS,Grades,Toggle,Thisriv,Satellite)
if Toggle.USGSpull
    RUNgh(Toggle)
end
if ~isempty(VS);
    if Toggle.validate
        for i = 1:length(VS)
            if ~isempty( VS(i).VS);
                Validation_tester_GC(VS(i).VS,Toggle);
                whofeelsvalidated_GC(VS(i).VS,Toggle);
            end
        end
        %rerun gradecheck
        [Grades]=gradelistreader2(Thisriv,Toggle,Satellite);
    end
    %% check VS sstructure to see where grades are needed
    
    for i = 1:length(VS)
        if ~isempty( VS(i).VS);
            [VS(i).VS] = GP(VS(i).VS,Grades);
        end
        if Toggle.SF==0;
           VSpuller2(VS(i).VS,Thisriv,Satellite{i});
        end
    end
    
end
end


