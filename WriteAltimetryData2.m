function WriteAltimetryData2(VS,Filterall,Toggle)

Ice = Toggle.IceData;

VSall=VS;
contname=true;


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
            
            vIDs.nsest=netcdf.defVar(ncid,'nsest','NC_DOUBLE',gradedimid);
            vIDs.nsemedianst=netcdf.defVar(ncid,'nsemedianst','NC_DOUBLE',gradedimid);
            vIDs.Rst=netcdf.defVar(ncid,'Rst','NC_DOUBLE',gradedimid);
            vIDs.stdst=netcdf.defVar(ncid,'stdst','NC_DOUBLE',gradedimid);
            vIDs.stdmedianst=netcdf.defVar(ncid,'stdmedianst','NC_DOUBLE',gradedimid);
            
            
            
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
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'Conventions', 'CF-1.6' ); % required to indicate that data is CF complient
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'institution', 'Ohio State University, School of Earth Sciences' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'source', 'MEaSUREs OSU ALT toolbox 2016' );
        keywordz='EARTH SCIENCE,TERRESTRIAL HYDROSPHERE,SURFACE WATER,SURFACE WATER PROCESSES/MEASUREMENTS,STAGE HEIGHT';
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'keywords', keywordz );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'keywords_vocabulary', 'Global Change Master Directory (GCMD)' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'cdm_data_type', 'THREDDS' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'creator_name', 'Coss,Steve' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'creator_email', 'Coss.31@osu.edu' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'project', 'MEaSUREs OSU' );
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'processing_level', 'processed and unprocessed L2 altimeter data from inside a river mask' );
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
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'date_created', datestr(Tstamp));
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'time_coverage_start',datestr(min(VS.AltDat.tAll)));
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'time_coverage_end',datestr(max(VS.AltDat.tAll)));
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
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_vertical_min',min(VS.AltDat.h));
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_vertical_units','m');
        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'geospatial_vertical_posative','up');
        
        
        
        
        
        
        %netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'history', '' );
        %netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'references', '' );
        
        %3.2 root group
        %3.2.1 coordinate units
        netcdf.putAtt(ncid,vIDs.Lat,'units','degree_north');
        netcdf.putAtt(ncid,vIDs.Lat,'long_name','latitude');
        netcdf.putAtt(ncid,vIDs.Lat,'standard_name','latitude');
        
        netcdf.putAtt(ncid,vIDs.Lon,'units','degree_east');
        netcdf.putAtt(ncid,vIDs.Lon,'long_name','longitude');
        netcdf.putAtt(ncid,vIDs.Lon,'standard_name','longitude');
        
        
        %3.2.2 other root group
        netcdf.putAtt(ncid,vIDs.ID,'long_name','reference_VS_ID');
        netcdf.putAtt(ncid,vIDs.ID,'coordinates','longitude latitude');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        netcdf.putAtt(ncid,vIDs.ID,'standard_name','reference_vs_id');
        
        netcdf.putAtt(ncid,vIDs.FlowDistance,'long_name','distance_from_river_mouth');
        netcdf.putAtt(ncid,vIDs.FlowDistance,'standard_name','distance_from_river_mouth');
        netcdf.putAtt(ncid,vIDs.FlowDistance,'units','km');
        
        
        netcdf.putAtt(ncid,vIDs.sat,'long_name','satellite');
        netcdf.putAtt(ncid,vIDs.sat,'standard_name','satellite');
        netcdf.putAtt(ncid,vIDs.rate,'units','Hz');
        
        netcdf.putAtt(ncid,vIDs.rate,'long_name','sampling rate');
        netcdf.putAtt(ncid,vIDs.rate,'standard_name','sampling_rate');
        
        netcdf.putAtt(ncid,vIDs.pass,'long_name','pass_number');
        netcdf.putAtt(ncid,vIDs.pass,'standard_name','pass_number');
        %
        if ~isfield(VS,'stats');
            netcdf.putAtt(ncid,vIDs.grade,'long_name','qualitative letter grade');
            netcdf.putAtt(ncid,vIDs.grade,'standard_name','qualitative_letter_grade');
        else
            netcdf.putAtt(ncid,vIDs.nse,'long_name','MAX nash sutcliffe efficiency');
            netcdf.putAtt(ncid,vIDs.nse,'standard_name','max_nash_sutcliffe_efficiency');
            
            netcdf.putAtt(ncid,vIDs.nsemedian,'long_name','median nash sutcliffe efficiency');
            netcdf.putAtt(ncid,vIDs.nsemedian,'standard_name','median_nash_sutcliffe_efficiency');
            
            netcdf.putAtt(ncid,vIDs.R,'long_name','correlation coefficient');
            netcdf.putAtt(ncid,vIDs.R,'standard_name','correlation_coefficient');
            
            netcdf.putAtt(ncid,vIDs.std,'long_name',' MIN standard deviation of error');
            netcdf.putAtt(ncid,vIDs.std,'standard_name','min_standard_deviation_of_error');
            netcdf.putAtt(ncid,vIDs.std,'units','m');
            
            netcdf.putAtt(ncid,vIDs.stdmedian,'long_name','median standard deviation of error');
            netcdf.putAtt(ncid,vIDs.stdmedian,'standard_name','median_standard_deviation_of_error');
            netcdf.putAtt(ncid,vIDs.stdmedian,'units','m');
            netcdf.putAtt(ncid,vIDs.prox,'long_name','gage proximity of most proximal gage');
            netcdf.putAtt(ncid,vIDs.prox,'standard_name','gage_proximity_of_most_proximal_gage');
            netcdf.putAtt(ncid,vIDs.prox,'units','m');
            
            netcdf.putAtt(ncid,vIDs.proxSTD,'long_name','standard deviation of error of most proximal gage');
            netcdf.putAtt(ncid,vIDs.proxSTD,'standard_name','standard_deviation_of_error_of_most_proximal_gage');
            netcdf.putAtt(ncid,vIDs.proxSTD,'units','m');
            
            netcdf.putAtt(ncid,vIDs.proxR,'long_name','correlation coefficient of most proximal gage');
            netcdf.putAtt(ncid,vIDs.proxR,'standard_name','correlation_coefficient_of_error_of_most_proximal_gage');
            
            netcdf.putAtt(ncid,vIDs.proxE,'long_name','Nash Sutcliffe efficiency of most proximal gage');
            netcdf.putAtt(ncid,vIDs.proxE,'standard_name','Nash_Sutcliffe_efficiency_of_most_proximal_gage');
            netcdf.putAtt(ncid,vIDs.proxE,'units','m')
            
            %v3
            netcdf.putAtt(ncid,vIDs.nsest,'long_name','MAX nash sutcliffe efficiency st');
            netcdf.putAtt(ncid,vIDs.nsest,'standard_name','max_nash_sutcliffe_efficiency st');
            
            netcdf.putAtt(ncid,vIDs.nsemedianst,'long_name','median nash sutcliffe efficiency st');
            netcdf.putAtt(ncid,vIDs.nsemedianst,'standard_name','median_nash_sutcliffe_efficiency st');
            
            netcdf.putAtt(ncid,vIDs.Rst,'long_name','correlation coefficient st');
            netcdf.putAtt(ncid,vIDs.Rst,'standard_name','correlation_coefficient st');
            
            netcdf.putAtt(ncid,vIDs.stdst,'long_name',' MIN standard deviation of error st');
            netcdf.putAtt(ncid,vIDs.stdst,'standard_name','min_standard_deviation_of_error st');
            netcdf.putAtt(ncid,vIDs.stdst,'units','m');
            
            netcdf.putAtt(ncid,vIDs.stdmedianst,'long_name','median standard deviation of error st');
            netcdf.putAtt(ncid,vIDs.stdmedianst,'standard_name','median_standard_deviation_of_error st');
            netcdf.putAtt(ncid,vIDs.stdmedianst,'units','m');
            
        end
        
        
        %3.3 sampling group
        netcdf.putAtt(sGroupID,vIDs.LandsatSceneID,'long_name','Landsat Scene ID');
        netcdf.putAtt(sGroupID,vIDs.LandsatSceneID,'standard_name','landsat_scene_id');
        
        netcdf.putAtt(sGroupID,vIDs.SampX,'long_name','Longitude Box Extents');
        netcdf.putAtt(sGroupID,vIDs.SampX,'standard_name','longitude_box_extents');
        netcdf.putAtt(sGroupID,vIDs.SampX,'units','degree_east');
        
        netcdf.putAtt(sGroupID,vIDs.SampY,'long_name','Latitude Box Extents');
        netcdf.putAtt(sGroupID,vIDs.SampY,'standard_name','latitude_box_extents');
        netcdf.putAtt(sGroupID,vIDs.SampY,'units','degree_north');
        
        %flags
        netcdf.putAtt(sGroupID,vIDs.Island,'long_name','Island Flag');
        netcdf.putAtt(sGroupID,vIDs.Island,'standard_name','island_flag');
        netcdf.putAtt(sGroupID,vIDs.Island,'Fill_value','-1');
        netcdf.putAtt(sGroupID,vIDs.Island,'valid_range','0,1');
        netcdf.putAtt(sGroupID,vIDs.Island,'flag_masks','1');
        netcdf.putAtt(sGroupID,vIDs.Island,'flag_meanings','island_present_in_polygon ');
        
        %3.4 Unprocessed GDR Data
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lon,'units','degree_east');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lon,'long_name','longitude');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lon,'standard_name','longitude');
        
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lat,'units','degree_north');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lat,'long_name','latitude');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_Lat,'standard_name','latitude');
        
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'units','meters_above_EGM2008_geoid');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'positive','up');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'long_name','unprocessed_heights');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'standard_name','unprocessed_heights');
        %netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_h,'coordinates','longitude latitude');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_sig0,'units','dB');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_sig0,'long_name','Sigma0');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_sig0,'standard_name','sigma0');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_pk,'units','-');
        
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_cyc,'units','-');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_cyc,'standard_name','altimiter_cycle');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_cyc,'long_name','Unprocessed_GDR_Altimiter_cycle');
        
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_t,'units','days since Jan-01-1900 00:00:00');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_t,'long_name','time');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_t,'standard_name','time');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_t,'calendar','standard');
        
        %flags
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'long_name','Good heights flag');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'standard_name','good_heights_flag');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'valid_range','0, 1');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'flag_masks','1');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_heightfilter,'flag _meenings','height_passed_filter');
        %
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'long_name','No_ice_flag');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'standard_name','no_ice_flag');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'valid_range','0, 1');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'flag_masks','1');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_icefilter,'flag_meenings','height_recorded_at_time_of_no_ice');
        %
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'long_name','Combined_good_heights_and_ice_free_flag');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'standard_name','combined_good_heights_and_ice_free_flag');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'valid_range','0, 1');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'flag_masks','1');
        netcdf.putAtt(UGDR_GroupID,vIDs.UGDR_allfilter,'flag_meenings','Ice_free_heights_that_passed_height_filter');
        
        
        %3.5  timeseries
        %3.5
        netcdf.putAtt(tGroupID,vIDs.time,'units','days since Jan-01-1900 00:00:00');
        netcdf.putAtt(tGroupID,vIDs.time,'calendar','standard');
        netcdf.putAtt(tGroupID,vIDs.time,'long_name','time');
        netcdf.putAtt(tGroupID,vIDs.time,'standard_name','time');
        
        netcdf.putAtt(tGroupID,vIDs.cycle,'units','-');
        netcdf.putAtt(tGroupID,vIDs.cycle,'long_name','altimiter cycle');
        netcdf.putAtt(tGroupID,vIDs.cycle,'standard_name','altimiter_cycle');
        
        netcdf.putAtt(tGroupID,vIDs.hbar,'units','meters_above_EGM2008_geoid');
        netcdf.putAtt(tGroupID,vIDs.hbar,'long_name','Average Height');
        netcdf.putAtt(tGroupID,vIDs.hbar,'standard_name','average_height');
        netcdf.putAtt(tGroupID,vIDs.hbar,'positive','up');
        
         netcdf.putAtt(tGroupID,vIDs.hbarST,'units','meters_above_EGM2008_geoid');
        netcdf.putAtt(tGroupID,vIDs.hbarST,'long_name','Average Height ST');
        netcdf.putAtt(tGroupID,vIDs.hbarST,'standard_name','average_height_ST');
        netcdf.putAtt(tGroupID,vIDs.hbarST,'positive','up');
        
        netcdf.putAtt(tGroupID,vIDs.hwbar,'units','meters_above_EGM2008_geoid');
        netcdf.putAtt(tGroupID,vIDs.hwbar,'long_name','Weighted Average Height');
        netcdf.putAtt(tGroupID,vIDs.hwbar,'standard_name','weighted_average__height');
        netcdf.putAtt(tGroupID,vIDs.hwbar,'positive','up');
        
        netcdf.putAtt(tGroupID,vIDs.sig0Avg,'units','dB');
        netcdf.putAtt(tGroupID,vIDs.sig0Avg,'long_name','Average Sigma0');
        netcdf.putAtt(tGroupID,vIDs.sig0Avg,'standard_name','average_sigma0');
        
        netcdf.putAtt(tGroupID,vIDs.pkAvg,'units','-');
        netcdf.putAtt(tGroupID,vIDs.pkAvg,'long_name','Average Peakiness');
        netcdf.putAtt(tGroupID,vIDs.pkAvg,'standard_name','average_peakiness');
        
        %3.6 filter
        netcdf.putAtt(fGroupID,vIDs.nND,'long_name','Number of Cycles without Data');
        netcdf.putAtt(fGroupID,vIDs.nND,'standard_name','number_of_cycles_without_data');
        netcdf.putAtt(fGroupID,vIDs.nND,'units','count');
        
        netcdf.putAtt(fGroupID,vIDs.riverh,'long_name','River elevation from filter file');
        netcdf.putAtt(fGroupID,vIDs.riverh,'standard_name','river_elevation_from_filter_file');
        netcdf.putAtt(fGroupID,vIDs.riverh,'units','meters_above_EGM2008_geoid');
        
        netcdf.putAtt(fGroupID,vIDs.maxh,'long_name','Maximum elevation allowed by filter');
        netcdf.putAtt(fGroupID,vIDs.maxh,'standard_name','maximum_elevation_allowed_by_filter');
        netcdf.putAtt(fGroupID,vIDs.maxh,'units','meters_above_EGM2008_geoid');
        
        netcdf.putAtt(fGroupID,vIDs.minh,'long_name','Minimum elevation allowed by filter');
        netcdf.putAtt(fGroupID,vIDs.minh,'standard_name','minimum_elevation_allowed_by_filter');
        netcdf.putAtt(fGroupID,vIDs.minh,'units','meters_above_EGM2008_geoid');
        
        netcdf.putAtt(fGroupID,vIDs.DEMused,'long_name','DEM used in height filter');
        netcdf.putAtt(fGroupID,vIDs.DEMused,'standard_name','dem_used_in_height_filter');
        %3.7 ice
        netcdf.putAtt(fGroupID,vIDs.icethaw,'long_name','Thaw dates for river');
        netcdf.putAtt(fGroupID,vIDs.icethaw,'standard_name','thaw_dates_for_river');
        
        netcdf.putAtt(fGroupID,vIDs.icefreeze,'long_name','Freeze dates for river');
        netcdf.putAtt(fGroupID,vIDs.icefreeze,'standard_name','freeze_dates_for_river');
        
        
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
            netcdf.putVar(ncid,vIDs.nsest,0,length(VS.stats),VS.stats.nsest);%grade
            netcdf.putVar(ncid,vIDs.nsemedianst,0,length(VS.stats),VS.stats.nsemedianst);%grade
            netcdf.putVar(ncid,vIDs.Rst,0,length(VS.stats),VS.stats.Rst);%grade
            netcdf.putVar(ncid,vIDs.stdst,0,length(VS.stats),VS.stats.stdst);%grade
            netcdf.putVar(ncid,vIDs.stdmedianst,0,length(VS.stats),VS.stats.stdmedianst);%grade
            
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
