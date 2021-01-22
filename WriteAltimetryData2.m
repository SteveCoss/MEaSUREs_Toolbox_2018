function WriteAltimetryData2(VS,Filterall,Toggle)

Ice = Toggle.IceData;

VSall=VS;
contname=true;
%datenum for jan1 1900
startdate=datenum(1900,1,1);

for i = 1:length(VSall)
    
    if VSall(i).AltDat.Write && ~strcmp(VSall(i).grade,'z') && ~strcmp(VSall(i).stats,'z')
        %% selection of correct filter and VS
        VS=VSall(i);
        Filterdx=find([Filterall.ID] == VS.Id);
        Filter=Filterall(Filterdx);
        %%
        if contname
            [cont] = contlookup(VS);
            fname=fullfile(Toggle.FinalProductdir,[ cont '_' VS.ID '.nc']);
        else
            fname=fullfile(Toggle.FinalProductdir,[ VS.ID '.nc']);
        end
        
        %% 1 extract dimensions from altimetry data
        nt=length(VS.AltDat.t); %number of measurement times
        ntAll=length(VS.AltDat.tAll); %total number of measurements
        
        %% 2 definitions
        ncid=netcdf.create(fname,'NETCDF4');
        
        %2.0 define groups
        tGroupID=netcdf.defGrp(ncid,'Timeseries');
        sGroupID=netcdf.defGrp(ncid,'Sampling');
        UGDR_GroupID=netcdf.defGrp(ncid,'Unprocessed GDR Data');
        fGroupID=netcdf.defGrp(ncid,'Filter');
        
        
        
        %2.1 other root group items
        %2.1.1 text string ids
        londimid = netcdf.defDim(ncid,'X',1);
        latdimid = netcdf.defDim(ncid,'Y',1);
        gradedimid = netcdf.defDim(ncid,'grade',1);
        distdimid= netcdf.defDim(ncid,'distance',1);
        filldimid= netcdf.defDim(ncid,'root',1);
        satdimid= netcdf.defDim(ncid,'sat',length(VS.Satellite));
        VSIDdimid= netcdf.defDim(ncid,'ID',length(VS.ID));
        
        
        
        
        %2.2.1 define coordinate variables
        vIDs.Lon=netcdf.defVar(ncid,'lon','NC_DOUBLE',londimid);
        vIDs.Lat=netcdf.defVar(ncid,'lat','NC_DOUBLE',latdimid);
        
        %2.2.2 define items
        vIDs.ID=netcdf.defVar(ncid,'ID','NC_CHAR',VSIDdimid);
        vIDs.sat=netcdf.defVar(ncid,'sat','NC_CHAR',satdimid);
        
        vIDs.FlowDistance=netcdf.defVar(ncid,'Flow_Dist','NC_DOUBLE',distdimid);
        vIDs.rate=netcdf.defVar(ncid,'rate','NC_DOUBLE',filldimid);
        vIDs.pass=netcdf.defVar(ncid,'pass','NC_INT',filldimid);
        if ~isfield(VS,'stats');
            vIDs.grade=netcdf.defVar(ncid,'grade','NC_CHAR',gradedimid);
        else
            vIDs.nse=netcdf.defVar(ncid,'nse','NC_DOUBLE',gradedimid);
            vIDs.nsemedian=netcdf.defVar(ncid,'nsemedian','NC_DOUBLE',gradedimid);
            vIDs.R=netcdf.defVar(ncid,'R','NC_DOUBLE',gradedimid);
            vIDs.std=netcdf.defVar(ncid,'std','NC_DOUBLE',gradedimid);
            vIDs.stdmedian=netcdf.defVar(ncid,'stdmedian','NC_DOUBLE',gradedimid);
            
            vIDs.prox=netcdf.defVar(ncid,'prox','NC_DOUBLE',gradedimid);
            vIDs.proxSTD=netcdf.defVar(ncid,'proxSTD','NC_DOUBLE',gradedimid);
            vIDs.proxR=netcdf.defVar(ncid,'proxR','NC_DOUBLE',gradedimid);
            vIDs.proxE=netcdf.defVar(ncid,'proxE','NC_DOUBLE',gradedimid);
            
            vIDs.nseSF=netcdf.defVar(ncid,'nsest','NC_DOUBLE',gradedimid);
            vIDs.nsemedianSF=netcdf.defVar(ncid,'nsemedianst','NC_DOUBLE',gradedimid);
            vIDs.RSF=netcdf.defVar(ncid,'Rst','NC_DOUBLE',gradedimid);
            vIDs.stdSF=netcdf.defVar(ncid,'stdst','NC_DOUBLE',gradedimid);
            vIDs.stdmedianSF=netcdf.defVar(ncid,'stdmedianst','NC_DOUBLE',gradedimid);
            
            
            
        end
        
        
        %2.3 sampling
        %2.3.1 dimensions
        SceneDimId = netcdf.defDim(sGroupID,'scene',length(VS.LSID));
        XDimId = netcdf.defDim(sGroupID,'X',length(VS.X)-1);
        
        YDimId = netcdf.defDim(sGroupID,'Y',length(VS.Y)-1);
        
        IceDimId= netcdf.defDim(sGroupID,'icedat',size(Ice,1));
        cDimId = netcdf.defDim(sGroupID,'coordinates',5);
        %2.3.2 definitions
        vIDs.LandsatSceneID=netcdf.defVar(sGroupID,'scene','NC_CHAR',SceneDimId);
        vIDs.SampX=netcdf.defVar(sGroupID,'lonbox','NC_DOUBLE',XDimId);
        vIDs.SampY=netcdf.defVar(sGroupID,'latbox','NC_DOUBLE',YDimId);
        vIDs.Island=netcdf.defVar(sGroupID,'island','NC_INT',SceneDimId);
        
        %2.4 Unprocessed GDR Data
        l3DimId = netcdf.defDim(UGDR_GroupID,'UGDR',ntAll);
        UGDRXDimId = netcdf.defDim(UGDR_GroupID,'X',ntAll);
        UGDRYDimId = netcdf.defDim(UGDR_GroupID,'Y',ntAll);
        UGDRZDimId = netcdf.defDim(UGDR_GroupID,'Z',ntAll);
        UGDRTDimId = netcdf.defDim(UGDR_GroupID,'T',ntAll);
        
        
        
        
        vIDs.UGDR_Lon=netcdf.defVar(UGDR_GroupID,'lon','NC_DOUBLE',UGDRXDimId);
        vIDs.UGDR_Lat=netcdf.defVar(UGDR_GroupID,'lat','NC_DOUBLE',UGDRYDimId);
        
        vIDs.UGDR_h=netcdf.defVar(UGDR_GroupID,'h','NC_DOUBLE',UGDRZDimId);
        
        
        vIDs.UGDR_sig0=netcdf.defVar(UGDR_GroupID,'sig0','NC_DOUBLE',l3DimId);
        vIDs.UGDR_pk=netcdf.defVar(UGDR_GroupID,'pk','NC_DOUBLE',l3DimId);
        vIDs.UGDR_cyc=netcdf.defVar(UGDR_GroupID,'cycle','NC_INT',l3DimId);
        
        vIDs.UGDR_t=netcdf.defVar(UGDR_GroupID,'time','NC_DOUBLE',UGDRTDimId);
        vIDs.UGDR_heightfilter=netcdf.defVar(UGDR_GroupID,'heightfilter','NC_INT',l3DimId);
        vIDs.UGDR_icefilter=netcdf.defVar(UGDR_GroupID,'icefilter','NC_INT',l3DimId);
        vIDs.UGDR_allfilter=netcdf.defVar(UGDR_GroupID,'allfilter','NC_INT',l3DimId);
        
        
        %2.5 timeseries
        tdimid = netcdf.defDim(tGroupID,'T',nt);
        Ztsdimid = netcdf.defDim(tGroupID,'Z',nt);
        tsdimid = netcdf.defDim(tGroupID,'TS',nt);
        vIDs.time=netcdf.defVar(tGroupID,'time','NC_DOUBLE',tdimid);
        vIDs.cycle=netcdf.defVar(tGroupID,'cycle','NC_INT',tsdimid);
        vIDs.hbar=netcdf.defVar(tGroupID,'hbar','NC_DOUBLE',Ztsdimid);
        vIDs.hwbar=netcdf.defVar(tGroupID,'hwbar','NC_DOUBLE',Ztsdimid);
        vIDs.sig0Avg=netcdf.defVar(tGroupID,'sig0bar','NC_DOUBLE',tsdimid);
        vIDs.pkAvg=netcdf.defVar(tGroupID,'pkbar','NC_DOUBLE',tsdimid);
        vIDs.hbarST=netcdf.defVar(tGroupID,'hbarST','NC_DOUBLE',Ztsdimid);
        
        
        %2.6 filter
        %%filter group needs approprate flag attributes (values/masks/meanings)
        IceDimId = netcdf.defDim(fGroupID,'T',size(Ice,1));
        demdimid = netcdf.defDim(fGroupID,'DEM',length(Filter.DEMused));
        fheightdimid = netcdf.defDim(fGroupID,'Z',1);
        
        
        vIDs.nND=netcdf.defVar(fGroupID,'nNODATA','NC_INT', []);
        vIDs.riverh=netcdf.defVar(fGroupID,'riverh','NC_DOUBLE',fheightdimid);
        vIDs.maxh=netcdf.defVar(fGroupID,'maxh','NC_DOUBLE', fheightdimid);
        vIDs.minh=netcdf.defVar(fGroupID,'minh','NC_DOUBLE', fheightdimid);
        vIDs.icethaw=netcdf.defVar(fGroupID,'icethaw','NC_DOUBLE', IceDimId);
        vIDs.icefreeze=netcdf.defVar(fGroupID,'icefreeze','NC_DOUBLE', IceDimId);
        vIDs.DEMused=netcdf.defVar(fGroupID,'DEMused','NC_CHAR', demdimid);
        
        
        
        
        
        
        %% 3  attributes
        %3.1 global
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'title',['GRRATS (Global River Radar Altimetry Time Series) Data for virtual station ' VS.ID]);
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'Conventions', 'CF-1.6, ACDD-1.3' ); % required to indicate that data is CF complient
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'institution', 'Ohio State University, School of Earth Sciences' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'source', 'MEaSUREs_OSU_RA_toolbox_2018' );
        keywordz='EARTH SCIENCE,TERRESTRIAL HYDROSPHERE,SURFACE WATER,SURFACE WATER PROCESSES/MEASUREMENTS,STAGE HEIGHT';
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'keywords', keywordz );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'keywords_vocabulary', 'Global Change Master Directory (GCMD)' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'cdm_data_type', 'THREDDS' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'creator_name', 'Coss,Steve' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'creator_email', 'Coss.31@osu.edu' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'project', 'MEaSUREs OSU' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'program', 'NASA Earth Science Data Systems (ESDS)' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'publisher_name', 'PO.DAAC (Physical Oceanography Distributed Active Archive Center)' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'publisher_email', 'podaac@podaac.jpl.nasa.gov' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'publisher_url', 'podaac.jpl.nasa.gov' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'publisher_type', 'Institution' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'publisher_institution', 'PO.DAAC' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'processing_level', 'L2' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'doi', '10.5067/PSGRA-SA2V2' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'cdm_data_type', 'station' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'processing_level', 'processed and unprocessed L2 altimeter data from inside a river mask' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'history','V1-2016;last updated 8.21.2019, Now includes ERS-1, ERS-2, TOPEX/POSEIDON, Jason-1, and Jason-2 data.' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'cdm_data_type', 'station' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'platform', 'ERS-1(L2),ERS-2(L2),TOPEX/POSEIDON(L2), Jason-1(L2),OSTM/Jason-2(L2),Jason-3(L2),Envisat(L2)' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'platform_vocabulary','NASA/GCMD Platform Keywords. Version 8.6');
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'instrument','RA(L2),RA-2(L2),ALT(TOPEX)(L2),POSEIDON-2(L2),POSEIDON-3(L2),POSEIDON-3b(L2)');
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'instrument_vocabulary','NASA/GCMD Platform Keywords. Version 8.6');
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'references','in review :doi.org/10.5194/essd-2019-84');
        %% summary
        sum ='The Global River Radar Altimeter Time Series (GRRATS) are river heights from OSTM/Jason-2 and Envisat that are conformed to look like river gauges via virtual stations (VS). The purpose of these heights are to provide satellite altimetric river height data in a form that is more recognizable to the observational community and as a way to get users use to using satellite data for river hydrology. GRRATS provides data from 914 VS on 39 of the world’s largest rivers (wider than 900m). River heights were processed with limits established by DEM data from inside the VS. When applicable, times of ice cover are also flagged consistently. To allow for maximum usability, all processing data is included (original L2 data, filtering limits, etc.). When possible, data was validated with in situ gauges. Other locations were assigned a qualitative letter grade, based on the amount of missing data, agreement with nearby VS and identifiable seasonal cycle. Validation information (quantitative or qualitative) is packaged with each VS’s data to aid the end user in selection the best time series for their particular task.';
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'id', 'GRRATS(Global River Radar Altimeter Time Series)' );
        
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'summary', sum );
        if strcmp(VS.Satellite,'Jason2')
            netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'time_coverage_resolution', '10 day' );
        else
            netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'time_coverage_resolution', '35 day' );
        end
        
        %time globals
        Tstamp=clock;
        [y,m,d,h,mi,s] = datevec(datestr(Tstamp));
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'date_created', [num2str(y) '-' num2str(m,'%02.f') '-' num2str(d,'%02.f') 'T' num2str(h,'%02.f') ':' num2str(mi,'%02.f') ':' num2str(s,'%02.f')]);
        [y,m,d,h,mi,s] = datevec(datestr(min(VS.AltDat.tAll)));
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'time_coverage_start',[num2str(y) '-' num2str(m,'%02.f') '-' num2str(d,'%02.f') 'T' num2str(h,'%02.f') ':' num2str(mi,'%02.f') ':' num2str(s,'%02.f')]);
        [y,m,d,h,mi,s] = datevec(datestr(max(VS.AltDat.tAll)));
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'time_coverage_end',[num2str(y) '-' num2str(m,'%02.f') '-' num2str(d,'%02.f') 'T' num2str(h,'%02.f') ':' num2str(mi,'%02.f') ':' num2str(s,'%02.f')]);
        % netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'time_coverage_duration',strcat(num2str(max(VS.AltDat.tAll)-min(VS.AltDat.tAll)),'days'));
        %geospatial globals
        ylimmin=min(VS.Y);
        ylimmax=max(VS.Y);
        xlimmin= min(VS.X);
        xlimmax=max(VS.X);
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_lon_min',xlimmin);
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_lon_max',xlimmax);
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_lon_units','degree_east');
        
        
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_lat_min',ylimmin);
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_lat_max',ylimmax);
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_lat_units','degree_north');
        
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_vertical_max',max(VS.AltDat.h));
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_vertical_min',min(VS.AltDat.h(VS.AltDat.h>-9999)));
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_vertical_units','m');
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_vertical_posative','up');
        
        
        
        
        
        
        %netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'history', '' );
        %netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'references', '' );
        
        %3.2 root group
        %3.2.1 coordinate units
        netcdf.putAtt(ncid,vIDs.Lat,'units','degrees_north');
        netcdf.putAtt(ncid,vIDs.Lat,'long_name','latitude');
        netcdf.putAtt(ncid,vIDs.Lat,'standard_name','latitude');
        netcdf.putAtt(ncid,vIDs.Lat,'axis','Y');
        
        netcdf.putAtt(ncid,vIDs.Lon,'units','degrees_east');
        netcdf.putAtt(ncid,vIDs.Lon,'long_name','longitude');
        netcdf.putAtt(ncid,vIDs.Lon,'standard_name','longitude');
        netcdf.putAtt(ncid,vIDs.Lon,'axis','X');
        
        
        %3.2.2 other root group
        netcdf.putAtt(ncid,vIDs.ID,'long_name','reference_VS_ID');
        netcdf.putAtt(ncid,vIDs.ID,'coordinates','longitude latitude');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        netcdf.putAtt(ncid,vIDs.ID,'comment','This is the ID number assigned to this VS for a specific river, altimeter, and crossing locaton.');
        
        
        netcdf.putAtt(ncid,vIDs.FlowDistance,'long_name','distance_from_river_mouth');%
        netcdf.putAtt(ncid,vIDs.FlowDistance,'units','km');
        netcdf.putAtt(ncid,vIDs.FlowDistance,'comment','This is the distance along the river centerline from the river mouth to this VS.');
        
        
        netcdf.putAtt(ncid,vIDs.sat,'long_name','satellite');
        netcdf.putAtt(ncid,vIDs.sat,'comment','The altimeter the data came from.');
        
        
        netcdf.putAtt(ncid,vIDs.rate,'units','Hz');
        netcdf.putAtt(ncid,vIDs.rate,'long_name','sampling rate');
        netcdf.putAtt(ncid,vIDs.rate,'comment','sampling rate of the altimeter');
        
        
        netcdf.putAtt(ncid,vIDs.pass,'long_name','pass_number');
        netcdf.putAtt(ncid,vIDs.pass,'comment','The altimeter pass number that crosses this VS.');
        %
        if ~isfield(VS,'stats');
            netcdf.putAtt(ncid,vIDs.grade,'long_name','qualitative letter grade');
            netcdf.putAtt(ncid,vIDs.grade,'comment','qualitative letter grade assigned by visiual inspection. There were no gages on this river');
            
        else
            netcdf.putAtt(ncid,vIDs.nse,'long_name','MAX nash sutcliffe efficiency');
            netcdf.putAtt(ncid,vIDs.nse,'comment','The best NSE evaluation for this VS. VS anomalies were compaired with all gages on the river.');
            
            
            
            netcdf.putAtt(ncid,vIDs.nsemedian,'long_name','median nash sutcliffe efficiency');
            netcdf.putAtt(ncid,vIDs.nsemedian,'comment','The median NSE evaluation for this VS. VS anomalies were compaired with all gages on the river.');
            
            
            netcdf.putAtt(ncid,vIDs.R,'long_name','correlation coefficient');
            netcdf.putAtt(ncid,vIDs.R,'comment','The highest correlation coefficient with this VS. VS anomalies were compaired with all gages on the river.');
            
            
            netcdf.putAtt(ncid,vIDs.std,'long_name','MIN standard deviation of error');
            netcdf.putAtt(ncid,vIDs.std,'units','m');
            netcdf.putAtt(ncid,vIDs.std,'comment','The lowest standard deviation of error at this VS. VS anomalies were compaired with all gages on the river.');
            
            netcdf.putAtt(ncid,vIDs.stdmedian,'long_name','median standard deviation of error');
            netcdf.putAtt(ncid,vIDs.stdmedian,'comment','The median standard deviation of error at this VS. VS anomalies were compaired with all gages on the river.');
            netcdf.putAtt(ncid,vIDs.stdmedian,'units','m');
            
            netcdf.putAtt(ncid,vIDs.prox,'long_name','gage proximity');
            netcdf.putAtt(ncid,vIDs.prox,'comment','The river centerline distance to the nearest gage.');
            netcdf.putAtt(ncid,vIDs.prox,'units','m');
            
            netcdf.putAtt(ncid,vIDs.proxSTD,'long_name','standard deviation nearest');
            netcdf.putAtt(ncid,vIDs.proxSTD,'comment','standard deviation of error of most proximal gage');
            netcdf.putAtt(ncid,vIDs.proxSTD,'units','m');
            
            netcdf.putAtt(ncid,vIDs.proxR,'long_name','correlation coefficient nearest');
            netcdf.putAtt(ncid,vIDs.proxR,'comment','correlation coefficient of most proximal gage');
            
            netcdf.putAtt(ncid,vIDs.proxE,'long_name','Nash Sutcliffe nearest');
            netcdf.putAtt(ncid,vIDs.proxE,'long_name','Nash Sutcliffe efficiency of most proximal gage');
            netcdf.putAtt(ncid,vIDs.proxE,'units','m')
            
            %v3
            netcdf.putAtt(ncid,vIDs.nseSF,'long_name','MAX nash sutcliffe efficiency SF');
            netcdf.putAtt(ncid,vIDs.nseSF,'comment','The highest NSE at this VS after statistical filtering. VS anomalies were compaired with all gages on the river.');
            
            netcdf.putAtt(ncid,vIDs.nsemedianSF,'long_name','median nash sutcliffe efficiency SF');
            netcdf.putAtt(ncid,vIDs.nsemedianSF,'comment','The median NSE at this VS after statistical filtering. VS anomalies were compaired with all gages on the river.');
            
            
            netcdf.putAtt(ncid,vIDs.RSF,'long_name','correlation coefficient SF');
            netcdf.putAtt(ncid,vIDs.RSF,'comment','The highest R at this VS after statistical filtering. VS anomalies were compaired with all gages on the river.');
            
            
            netcdf.putAtt(ncid,vIDs.stdSF,'long_name','MIN standard deviation of error SF');
            netcdf.putAtt(ncid,vIDs.stdSF,'comment','The lowest standard deviation of error at this VS after statistical filtering. VS anomalies were compaired with all gages on the river.');
            netcdf.putAtt(ncid,vIDs.stdSF,'units','m');
            
            netcdf.putAtt(ncid,vIDs.stdmedianSF,'long_name','median standard deviation of error SF');
            netcdf.putAtt(ncid,vIDs.stdmedianSF,'comment','The median standard deviation of error at this VS after statistical filtering. VS anomalies were compaired with all gages on the river.');
            netcdf.putAtt(ncid,vIDs.stdmedianSF,'units','m');
            
        end
        
        
        %3.3 sampling group
        netcdf.putAtt(sGroupID,vIDs.LandsatSceneID,'long_name','Landsat Scene ID');
        netcdf.putAtt(sGroupID,vIDs.LandsatSceneID,'comment','Landsat Scene ID used in drawing extracion polygon');
        
        
        netcdf.putAtt(sGroupID,vIDs.SampX,'long_name','Longitude Box Extents');
        netcdf.putAtt(sGroupID,vIDs.SampX,'comment','longitud of the maximum extent of extraction polygon');
        netcdf.putAtt(sGroupID,vIDs.SampX,'units','degree_east');
        netcdf.putAtt(sGroupID,vIDs.SampX,'axis','X');
        
        netcdf.putAtt(sGroupID,vIDs.SampY,'long_name','Latitude Box Extents');
        netcdf.putAtt(sGroupID,vIDs.SampY,'comment','Latitude of the maximum extent of extraction polygon');
        netcdf.putAtt(sGroupID,vIDs.SampY,'units','degree_north');
        netcdf.putAtt(sGroupID,vIDs.SampY,'axis','Y');
        
        %flags
        netcdf.putAtt(sGroupID,vIDs.Island,'long_name','Island Flag');
        netcdf.putAtt(sGroupID,vIDs.Island,'comment','Flag for the presence of an island in the landsat scene used to draw the extracion polygon');
        %netcdf.putAtt(sGroupID,vIDs.Island,'_Fillvalue',-1);
        netcdf.defVarFill(sGroupID,vIDs.Island,false,-1);
%         netcdf.putAtt(sGroupID,vIDs.Island,'valid_range','0, 1');
%         netcdf.putAtt(sGroupID,vIDs.Island,'flag_masks','1,0');
%         netcdf.putAtt(sGroupID,vIDs.Island,'flag_meanings','island_present_in_polygon ');
        
        %3.4 Unprocessed GDR Data
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lon,'units','degrees_east');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lon,'long_name','longitude');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lon,'standard_name','longitude');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lon,'axis','X');
        
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lat,'units','degrees_north');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lat,'long_name','latitude');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lat,'standard_name','latitude');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lat,'axis','Y');
        
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'units','m');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'positive','up');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'long_name','unprocessed_height_above_EGM08');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'standard_name','height');
        %netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'_FillValue',-9999);
        netcdf.defVarFill(UGDR_GroupID,vIDs.UGDR_h,false,-9998);
        %         netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'grid_mapping','EGM08');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'valid_min',min(VS.AltDat.h));
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'valid_max',max(VS.AltDat.h(VS.AltDat.h>-9999)))
     
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'axis','Z');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'coordinate','T');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'comment','These are pre-averaged GDR data with respect to EGM08 geoid');
        
        
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_sig0,'units','dB');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_sig0,'long_name','Sigma0');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_sig0,'comment','Altimeter backscatter coefficient. These are pre-averaged GDR data');
        
        %netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_pk,'units','-');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_pk,'long_name','Peakiness');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_pk,'comment','The peakiness of the measurement.These are pre-averaged GDR data.');
        
        %netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_cyc,'units','-');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_cyc,'comment','The cycle number of the measurement.These are pre-averaged GDR data.');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_cyc,'long_name','Unprocessed_GDR_Altimiter_cycle');
        
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_t,'units','days since 1901-01-01T00:00:00');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_t,'long_name','time');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_t,'standard_name','time');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_t,'calendar','standard');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_t,'axis','T');
        
        %flags
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'long_name','Good heights flag');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'valid_range','0, 1');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'flag_masks','1');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'flag_meaning','height_passed_filter');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'comment','Flag for GDR heights that passed the height filter.These are pre-averaged GDR data.');
        %
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'long_name','No_ice_flag');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'valid_range','0, 1');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'flag_masks','1');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'flag_meaning','height_recorded_at_time_of_no_ice');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'comment','A flag for measurements without ice. These are pre-averaged GDR data.');
        %
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'long_name','Combined_good_heights_and_ice_free_flag');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'valid_range','0, 1');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'flag_masks','1');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'flag_meaning','Ice_free_heights_that_passed_height_filter');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'comment','A flag that combines the other two. This flag will provide the heigts that are then averaged to create the final time series.');
        
        
        %3.5  timeseries
        %3.5
        netcdf.putAtt(tGroupID,vIDs.time,'units','days since 1901-01-01T00:00:00');
        netcdf.putAtt(tGroupID,vIDs.time,'calendar','standard');
        netcdf.putAtt(tGroupID,vIDs.time,'long_name','time');
        netcdf.putAtt(tGroupID,vIDs.time,'standard_name','time');
        netcdf.putAtt(tGroupID,vIDs.time,'axis','T');
        
        
        netcdf.putAtt(tGroupID,vIDs.cycle,'long_name','altimiter cycle');
        netcdf.putAtt(tGroupID,vIDs.cycle,'comment','The altimeter cycle for each pass.');
        %netcdf.putAtt(tGroupID,vIDs.cycle,'coordinate','Z');
        
        
        netcdf.putAtt(tGroupID,vIDs.hbar,'units','m');
        netcdf.putAtt(tGroupID,vIDs.hbar,'long_name','Average_Height_above_EGM08');
        netcdf.putAtt(tGroupID,vIDs.hbar,'standard_name','height');
        %         %netcdf.putAtt(tGroupID,vIDs.hbar,'grid_mapping','EGM08');
        %netcdf.putAtt(ncid,vIDs.hbar,'_FillValue',-9999);
        netcdf.defVarFill(tGroupID,vIDs.hbar,false,-9998);
        netcdf.putAtt(tGroupID,vIDs.hbar,'positive','up');
        netcdf.putAtt(tGroupID,vIDs.hbar,'axis','Z');
        netcdf.putAtt(tGroupID,vIDs.hbar,'valid_min',min(VS.AltDat.hbar));
        netcdf.putAtt(tGroupID,vIDs.hbar,'valid_max',max(VS.AltDat.hbar(VS.AltDat.hbar>-9999)))
        netcdf.putAtt(tGroupID,vIDs.hbar,'coordinate','T');
        netcdf.putAtt(tGroupID,vIDs.hbar,'comment','Pass averaged and filtered river surface heights with respect to EGM08 Geoid)');
        
        netcdf.putAtt(tGroupID,vIDs.hbarST,'units','m');
        netcdf.putAtt(tGroupID,vIDs.hbarST,'long_name','Average_Height_above_EGM08_SF');
        netcdf.putAtt(tGroupID,vIDs.hbarST,'standard_name','height');
%         netcdf.putAtt(tGroupID,vIDs.hbarST,'grid_mapping','EGM08');
        netcdf.putAtt(tGroupID,vIDs.hbarST,'positive','up');
        netcdf.putAtt(tGroupID,vIDs.hbarST,'valid_min',min(VS.AltDat.V3hbar));
        netcdf.putAtt(tGroupID,vIDs.hbarST,'valid_max',max(VS.AltDat.V3hbar(VS.AltDat.V3hbar>-9999)))
        netcdf.defVarFill(tGroupID,vIDs.hbarST,false,-9998);
        %netcdf.putAtt(tGroupID,vIDs.hbarST,'axis','Z');
        netcdf.putAtt(tGroupID,vIDs.hbarST,'coordinate','T');
        netcdf.putAtt(tGroupID,vIDs.hbarST,'comment','Data have undergone statistical window filtering and outlier removal prior to height and ice filtering and pass averaging (referenced to EGM08 Geoid)');
        
        netcdf.putAtt(tGroupID,vIDs.hwbar,'units','m');
        netcdf.putAtt(tGroupID,vIDs.hwbar,'long_name','Weighted_Average_Height_above_EGM08');
        netcdf.putAtt(tGroupID,vIDs.hwbar,'standard_name','height');
        %netcdf.putAtt(ncid,vIDs.hbar,'_FillValue',-9999);
        netcdf.defVarFill(tGroupID,vIDs.hwbar,false,-9998);
%         netcdf.putAtt(tGroupID,vIDs.hwbar,'grid_mapping','EGM08');
        netcdf.putAtt(tGroupID,vIDs.hwbar,'positive','up');
          netcdf.putAtt(tGroupID,vIDs.hwbar,'valid_min',min(VS.AltDat.hwbar));
        netcdf.putAtt(tGroupID,vIDs.hwbar,'valid_max',max(VS.AltDat.hwbar(VS.AltDat.hwbar>-9999)))
        %netcdf.putAtt(tGroupID,vIDs.hwbar,'axis','Z');
        netcdf.putAtt(tGroupID,vIDs.hwbar,'coordinate','T');
        netcdf.putAtt(tGroupID,vIDs.hwbar,'comment','Sigma0 weighted pass average heights (referenced to EGM08 Geoid)');
        
        netcdf.putAtt(tGroupID,vIDs.sig0Avg,'units','decibel');
        netcdf.putAtt(tGroupID,vIDs.sig0Avg,'long_name','Average Sigma0');
        netcdf.putAtt(tGroupID,vIDs.sig0Avg,'comment','Pass averaged backscatter coefficient');
        
        netcdf.putAtt(tGroupID,vIDs.pkAvg,'units','-');
        netcdf.putAtt(tGroupID,vIDs.pkAvg,'long_name','Average Peakiness');
        netcdf.putAtt(tGroupID,vIDs.pkAvg,'comment','Pass averaged Peakiness');
        %netcdf.putAtt(tGroupID,vIDs.pkAvg,'standard_name','average_peakiness');
        
        %3.6 filter
        netcdf.putAtt(fGroupID,vIDs.nND,'long_name','Number of Cycles without Data');
        %netcdf.putAtt(fGroupID,vIDs.nND,'standard_name','number_of_cycles_without_data');
        netcdf.putAtt(fGroupID,vIDs.nND,'units','count');
        
        netcdf.putAtt(fGroupID,vIDs.riverh,'long_name','River_elevation_from_filter_file_above_EGM08_geoid');
        netcdf.putAtt(fGroupID,vIDs.riverh,'standard_name','height');
%         netcdf.putAtt(fGroupID,vIDs.riverh,'grid_mapping','EGM08');
        netcdf.putAtt(fGroupID,vIDs.riverh,'axis','Z');
        netcdf.putAtt(fGroupID,vIDs.riverh,'positive','up');
        netcdf.putAtt(fGroupID,vIDs.riverh,'units','m');
        netcdf.putAtt(fGroupID,vIDs.riverh,'comment','This is the DEM based altitude of the VS location. Filter limits are constructed around this value (referenced to EGM08 Geoid)');
        
        netcdf.putAtt(fGroupID,vIDs.maxh,'long_name','Maximum_elevation_allowed_by_filter_above_EGM08_geoid');
        netcdf.putAtt(fGroupID,vIDs.maxh,'standard_name','height');
%         netcdf.putAtt(fGroupID,vIDs.maxh,'grid_mapping','EGM08');
        %netcdf.putAtt(fGroupID,vIDs.maxh,'axis','Z');
        netcdf.putAtt(fGroupID,vIDs.maxh,'positive','up');
        netcdf.putAtt(fGroupID,vIDs.maxh,'units','m');
        
        netcdf.putAtt(fGroupID,vIDs.minh,'long_name','Minimum_elevation_allowed_by_filter_above_EGM08_geoid');
        netcdf.putAtt(fGroupID,vIDs.minh,'standard_name','height');
%         netcdf.putAtt(fGroupID,vIDs.minh,'grid_mapping','EGM08');
        %netcdf.putAtt(fGroupID,vIDs.minh,'axis','Z');
        netcdf.putAtt(fGroupID,vIDs.minh,'positive','up');
        netcdf.putAtt(fGroupID,vIDs.minh,'units','m');
        
        netcdf.putAtt(fGroupID,vIDs.DEMused,'long_name','DEM_used_in_height_filter');
        netcdf.putAtt(fGroupID,vIDs.DEMused,'comment','specifies the DEM used to construct the height filter for this VS');
        
        
        %3.7 ice
        netcdf.putAtt(fGroupID,vIDs.icethaw,'long_name','Thaw_dates_for_river');
        netcdf.putAtt(tGroupID,vIDs.icethaw,'units','days since 1901-01-01T00:00:00');
        netcdf.putAtt(tGroupID,vIDs.time,'standard_name','time');
        netcdf.putAtt(tGroupID,vIDs.time,'axis','T');
        netcdf.putAtt(tGroupID,vIDs.time,'comment','Date where this VS thawed');
        
        netcdf.putAtt(fGroupID,vIDs.icefreeze,'long_name','Freeze_dates_for_river');
        netcdf.putAtt(tGroupID,vIDs.icethaw,'units','days since 1901-01-01T00:00:00');
        netcdf.putAtt(tGroupID,vIDs.time,'standard_name','time');
        netcdf.putAtt(tGroupID,vIDs.time,'axis','T');        
        netcdf.putAtt(tGroupID,vIDs.time,'comment','date where this VS froze');
        
        netcdf.endDef(ncid);
        
        
        %% 4 variables
        %4.1 root group
        netcdf.putVar(ncid,vIDs.Lon,0,length(VS.Lon),VS.Lon);
        netcdf.putVar(ncid,vIDs.Lat,0,length(VS.Lat),VS.Lat);
        netcdf.putVar(ncid,vIDs.ID,0,length(VS.ID),VS.ID);
        netcdf.putVar(ncid,vIDs.FlowDistance,0,length(VS.FLOW_Dist),VS.FLOW_Dist/1000); %convert m->km
        netcdf.putVar(ncid,vIDs.sat,0,length(VS.Satellite),VS.Satellite);
        netcdf.putVar(ncid,vIDs.rate,0,length(VS.Rate),VS.Rate);
        netcdf.putVar(ncid,vIDs.pass,0,length(VS.Pass),VS.Pass);
        if ~isfield(VS,'stats');
            netcdf.putVar(ncid,vIDs.grade,0,length(VS.grade),VS.grade);%grade
        else
            netcdf.putVar(ncid,vIDs.nse,0,length(VS.stats),VS.stats.nse);%grade
            netcdf.putVar(ncid,vIDs.nsemedian,0,length(VS.stats),VS.stats.nsemedian);%grade
            netcdf.putVar(ncid,vIDs.R,0,length(VS.stats),VS.stats.R);%grade
            netcdf.putVar(ncid,vIDs.std,0,length(VS.stats),VS.stats.std);%grade
            netcdf.putVar(ncid,vIDs.stdmedian,0,length(VS.stats),VS.stats.stdmedian);%grade
            
            %prox
            netcdf.putVar(ncid,vIDs.prox,0,length(VS.stats),VS.stats.prox);%grade
            netcdf.putVar(ncid,vIDs.proxSTD,0,length(VS.stats),VS.stats.proxSTD);%grade
            netcdf.putVar(ncid,vIDs.proxR,0,length(VS.stats),VS.stats.proxR);%grade
            netcdf.putVar(ncid,vIDs.proxE,0,length(VS.stats),VS.stats.proxE);%grade
            %v3
            netcdf.putVar(ncid,vIDs.nseSF,0,length(VS.stats),VS.stats.nsest);%grade
            netcdf.putVar(ncid,vIDs.nsemedianSF,0,length(VS.stats),VS.stats.nsemedianst);%grade
            netcdf.putVar(ncid,vIDs.RSF,0,length(VS.stats),VS.stats.Rst);%grade
            netcdf.putVar(ncid,vIDs.stdSF,0,length(VS.stats),VS.stats.stdst);%grade
            netcdf.putVar(ncid,vIDs.stdmedianSF,0,length(VS.stats),VS.stats.stdmedianst);%grade
            
        end
        
        
        
        
        
        %4.2 sampling
        netcdf.putVar(sGroupID,vIDs.LandsatSceneID,0,length(VS.LSID),VS.LSID)
        netcdf.putVar(sGroupID,vIDs.SampX,VS.X(1:end-1));
        netcdf.putVar(sGroupID,vIDs.SampY,VS.Y(1:end-1));
        netcdf.putVar(sGroupID,vIDs.Island,0,length(VS.Island),VS.Island);
        
        %4.3 Unprocessed GDR Data
        %datenum for jan1 1900
        startdate=datenum(1900,1,1);
        
        netcdf.putVar(UGDR_GroupID,vIDs.UGDR_Lon,VS.AltDat.lon);
        netcdf.putVar(UGDR_GroupID,vIDs.UGDR_Lat,VS.AltDat.lat);
        
        netcdf.putVar(UGDR_GroupID,vIDs.UGDR_h,VS.AltDat.h);
        netcdf.putVar(UGDR_GroupID,vIDs.UGDR_sig0,VS.AltDat.sig0);
        netcdf.putVar(UGDR_GroupID,vIDs.UGDR_pk,VS.AltDat.PK);
        netcdf.putVar(UGDR_GroupID,vIDs.UGDR_cyc,VS.AltDat.c);
        TiMe=VS.AltDat.tAll-startdate;
        netcdf.putVar(UGDR_GroupID,vIDs.UGDR_t,TiMe);
        netcdf.putVar(UGDR_GroupID,vIDs.UGDR_heightfilter,VS.AltDat.iGoodH+0);
        netcdf.putVar(UGDR_GroupID,vIDs.UGDR_icefilter,VS.AltDat.IceFlag+0);
        netcdf.putVar(UGDR_GroupID,vIDs.UGDR_allfilter,VS.AltDat.iGood+0);
        
        %4.4 timeseries
        netcdf.putVar(tGroupID,vIDs.time,VS.AltDat.t-startdate);
        netcdf.putVar(tGroupID,vIDs.cycle,VS.AltDat.ci);
        netcdf.putVar(tGroupID,vIDs.hbar,VS.AltDat.hbar);
        netcdf.putVar(tGroupID,vIDs.hbarST,VS.AltDat.V3hbar);
        netcdf.putVar(tGroupID,vIDs.hwbar,VS.AltDat.hwbar);
        netcdf.putVar(tGroupID,vIDs.sig0Avg,VS.AltDat.sig0Avg);
        
        %4.5 filter
        netcdf.putVar(fGroupID,vIDs.nND,VS.AltDat.nNODATA);
        netcdf.putVar(fGroupID,vIDs.riverh,Filter.AbsHeight);
        netcdf.putVar(fGroupID,vIDs.maxh,Filter.AbsHeight+Filter.MaxFlood);
        netcdf.putVar(fGroupID,vIDs.minh,Filter.AbsHeight-Filter.MinFlood);
        netcdf.putVar(fGroupID,vIDs.DEMused,0,length(Filter.DEMused), Filter.DEMused);
        
        %4.6 ice
        if size(Ice,1)>2
            netcdf.putVar(fGroupID,vIDs.icethaw,Ice(:,2)-startdate);
            netcdf.putVar(fGroupID,vIDs.icefreeze,Ice(:,3)-startdate);
        end
        
        % close
        netcdf.close(ncid);
    end
end

return
