function [VS,Ncyc] = Cycle_Rate(VS,satellite,i);

%This is the highest cycle number from the platform not the number of
%cycles
if satellite(1:2)=='En'
    Ncyc.max=94;
    Ncyc.ct=88;
    VS(i).Rate=18; %Hz
    
else if satellite(1)=='J'
        Ncyc.max=303;
         Ncyc.ct=303;
        VS(i).Rate=20; %Hz
    else if satellite(1:4)=='ERS2'%need to correct these cycle numbers
            Ncyc.max=85;
             Ncyc.ct=85;
            VS(i).Rate=20; %Hz
        else if satellite(1:2)=='To'
                Ncyc.max=481;
                 Ncyc.ct=482;
                VS(i).Rate=10; %Hz
            else if satellite(1:5)=='ERS1g'%need to correct these cycle numbers
                    Ncyc.max=156;
                    Ncyc.ct=12;
                    VS(i).Rate=20; %Hz
                else if satellite(1:5)=='ERS1c'%need to correct these cycle numbers
                        Ncyc.max=101;
                          Ncyc.ct=19;
                        VS(i).Rate=20; %Hz
                        else if satellite(1:5)=='SARAL'%need to correct these cycle numbers
                        Ncyc.max=35;
                          Ncyc.ct=35;
                        VS(i).Rate=40; %Hz
                            end
                    end
                end
            end
        end
    end
end
end