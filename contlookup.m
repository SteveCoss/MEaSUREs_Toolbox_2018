%river continent lookup
function [cont] = contlookup(VS);

if strcmp(VS.Riv,'Congo')||strcmp(VS.Riv,'Nile')||strcmp(VS.Riv,'Niger')||strcmp(VS.Riv,'Zambezi');
    cont='Africa';
else if strcmp(VS.Riv,'Volga')||strcmp(VS.Riv,'Mezen')||strcmp(VS.Riv,'Pechora');
        cont='Europe';
    else if strcmp(VS.Riv,'Columbia')||strcmp(VS.Riv,'Mackenzie')||strcmp(VS.Riv,'Mississippi')||strcmp(VS.Riv,'StLawrence')||strcmp(VS.Riv,'Susquehanna')||strcmp(VS.Riv,'Yukon');
            cont='North_America';
        else if strcmp(VS.Riv,'Amazon')||strcmp(VS.Riv,'Courantyne')||strcmp(VS.Riv,'Essequibo')||strcmp(VS.Riv,'Magdalena')||strcmp(VS.Riv,'Oiapoque')||strcmp(VS.Riv,'Orinoco')||strcmp(VS.Riv,'Parana')||strcmp(VS.Riv,'SaoFrancisco')||strcmp(VS.Riv,'Tocantins')||strcmp(VS.Riv,'Uruguay');
                cont='South_America';
            else
                cont='Asia';
            end
        end
    end
end
return

