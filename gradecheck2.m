%gradecheck
function [VS] =gradecheck(VS,Grades,Toggle,Thisriv,Satellite)
if ~isempty(VS);
if Toggle.validate
    for i = 1:length(VS)
        
    Validation_tester_GC(VS(i).VS,Toggle);
    whofeelsvalidated_GC(VS(i).VS,Toggle);
    end
    %rerun gradecheck
    [Grades]=gradelistreader2(Thisriv,Toggle,Satellite);
end
%% check VS sstructure to see where grades are needed

for i = 1:length(VS)
   
    [VS(i).VS] = GP(VS(i).VS,Grades);
end
end
end


