function [Altimetry,DEM,GDat,nodata] = GetAltimetry(VS,Ncyc,Toggle)

%2.1) Read in height & sigma0 data
fname=[VS.ID '_' num2str(VS.Rate) 'hz'];
fnamefull=fullfile(Toggle.RAdir,fname);
delimiterIn = {' ','  ','   ','    '};
fid=fopen(fnamefull);
    GDat=-1;

if fid==-1
    Altimetry.c=[];
    DEM=0;
else if all(fgetl(fid)~= -1)
        formatSpec = '%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
        datah = textscan(fid,formatSpec,'headerlines',3,'CollectOutput',true,'Delimiter', '', 'WhiteSpace', '','ReturnOnError',false);
        fclose(fid);
        datah=datah{1};
       
        Altimetry.c=datah(:,1);
        Altimetry.h=datah(:,2);
        if length(Altimetry.h)>20
            GDat=VS.Id;
        end
        tMJD=datah(:,3);
        
        Altimetry.sig0=datah(:,4);
        Altimetry.lon=datah(:,5);
        Altimetry.lat=datah(:,6);
        Altimetry.PK=datah(:,7);
        
        offdate =datenum(2000, 1, 1, 0, 0, 0) -51544; %from Chan email 3 Apr 2014
        Altimetry.tAll=tMJD+offdate;
        
        %2.2) Process heights cycle & time info
        [Altimetry.ci,i]=unique(Altimetry.c);
        Altimetry.t=Altimetry.tAll(i);
        
        Altimetry.cmax = Ncyc.max;%this is how man cycles not the cycle number Some alts need this consideration
        Altimetry.call=Altimetry.cmax-Ncyc.ct:Altimetry.cmax;
        Altimetry.GDRMissing=false(size(Altimetry.call)); %initiate
        
        for i=1:length(Altimetry.call),
            if ~any(Altimetry.ci==Altimetry.call(i)),
                Altimetry.GDRMissing(i)=true;
            end
        end
        
        %% read DEM data
        %ers DEM info is in a different format
        if strcmp(VS.Satellite,'Envisat') || strcmp(VS.Satellite,'Jason2') || strcmp(VS.Satellite,'Jason1')  || strcmp(VS.Satellite,'Jason3')
        
        delimiter = {' ','  ','   ','    '};
        endRow = 3;
        
        %  formatSpec='%*[#]%d%*f%*f';
        formatSpec = '%*s%f%f%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
        %formatSpec = '%*3s%10s%*15s%*[^\n\r]';
        else
            delimiter = {','};
            endRow=3;
          
            formatSpec = '%s%s%s';
        end
        fid=fopen(fnamefull);
     
            Altimetry.demDat=textscan(fid,formatSpec, endRow,... 
                'Delimiter',delimiter,'EmptyValue',NaN,'ReturnOnError', false);
         fclose(fid);
        if ~strcmp(VS.Satellite,'Envisat') && ~strcmp(VS.Satellite,'Jason2')&& ~strcmp(VS.Satellite,'Jason1') && ~strcmp(VS.Satellite,'Jason3')
            for k = 1:3;
                for m=1:length( Altimetry.demDat{1,k});
                    delimiter = {'='};
                    formatSpec = '%*s%f';
                    Altimetry.demDat{1,k}(m)= textscan(Altimetry.demDat{1,k}{m},...
                        formatSpec, 'Delimiter',delimiter,... 
                        'EmptyValue',NaN,'ReturnOnError', false);
                end
                 Altimetry.demDat{1,k} = cell2mat(Altimetry.demDat{1,k});
            end
        end
        
        
        DEM=Altimetry.demDat{1}';
        Altimetry.AvgGradient=Altimetry.demDat{2}';
        Altimetry.RMSGradient=Altimetry.demDat{3}';
    else
        GDat=-1;
        Altimetry.c=[];
        DEM=[-9999,-9999,-9999];
    end
end


return
