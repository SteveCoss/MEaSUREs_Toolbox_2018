function [VS]=Qfilter(VS,loadswitch);
for i=1:length(VS)
    if ~isempty(VS(i).grade)& isstruct(VS(i).grade)
        if VS(i).grade.nse >loadswitch.Qfilterthreshold
            GG(i)=1;
        else
            GG(i)=0;
        end
    else
        GG(i)=0;
    end
    VS=VS(find(GG==1));
end
end