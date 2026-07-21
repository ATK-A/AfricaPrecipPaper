%% Load some useful things for figure plotting and storing output

load('RBcolgradcon.mat')
% Coastline
S = shaperead('landareas','UseGeoCoords',true);

% lat-long limits for plotting
latlim = [-90 90];
latlim2 = [-30 30];
lonlim = [-180 180];
Mlon = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_CanESM5_ssp585_r1i1p1f1_gn_201501-210012.nc','longitude');
Mlat = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_CanESM5_ssp585_r1i1p1f1_gn_201501-210012.nc','latitude');

% models = {'CanESM5 r8i1p1f1','NorESM2-LM r1i1p1f1','CESM2-WACCM r1i1p1f1','ACCESS-ESM1-5 r3i1p1f1','GFDL-ESM4 r1i1p1f1'};
% models1 = {'CanESM5','NorESM2_LM','CESM2_WACCM','ACCESS_ESM1_5','GFDL_ESM4'};

SSTanom_all = nan(360,180,10); % lat x lon x models
Mod_P = nan(10,360,2); % models x months x time periods
SSTbase_P_corr = nan(length(Mlon(:,1)),length(Mlon(1,:)),10,2);
SSTfut_P_corr = nan(length(Mlon(:,1)),length(Mlon(1,:)),10,2);

figure
set(gcf, 'color', 'w');
colormap(RBcolgradcon)


for m = 1:10
    %% Load data for each model

    % SST data & lat/long
    % SST data
    disp(['Loading ',num2str(m)])
    SSTbase = ncread(['/Volumes/DataDrive/CMIP6/tos/tos_Omon_CanESM5_historical_r',num2str(m),'i1p1f1_gn_185001-201412.nc'],'tos');
    SSTfut = ncread(['/Volumes/DataDrive/CMIP6/tos/tos_Omon_CanESM5_ssp585_r',num2str(m),'i1p1f1_gn_201501-210012.nc'],'tos');
    Mlon = ncread(['/Volumes/DataDrive/CMIP6/tos/tos_Omon_CanESM5_ssp585_r',num2str(m),'i1p1f1_gn_201501-210012.nc'],'longitude');
    Mlat = ncread(['/Volumes/DataDrive/CMIP6/tos/tos_Omon_CanESM5_ssp585_r',num2str(m),'i1p1f1_gn_201501-210012.nc'],'latitude');

    % Precip data (all months)
    Panom = ncread(['../ESMValTool/output/CMIP6_allmonths/change/CMIP6_CanESM5_Amon_historical-ssp585_r',num2str(m),'i1p1f1_pr_gn_1985-2099.nc'],'pr') * 86400;
    Pbase = ncread(['../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_CanESM5_Amon_historical-ssp585_r',num2str(m),'i1p1f1_pr_gn_1985-2014.nc'],'pr') * 86400;
    Plon = ncread(['../ESMValTool/output/CMIP6_allmonths/change/CMIP6_CanESM5_Amon_historical-ssp585_r',num2str(m),'i1p1f1_pr_gn_1985-2099.nc'],'lon');
    Plat = ncread(['../ESMValTool/output/CMIP6_allmonths/change/CMIP6_CanESM5_Amon_historical-ssp585_r',num2str(m),'i1p1f1_pr_gn_1985-2099.nc'],'lat');

    % Need monthly mean for baseline
    month_mean = nan(length(Plon(:,1)),length(Plat(:,1)),12);
    for i = 1:12
        month_mean(:,:,i) = mean(ncread(['../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_CanESM5_Amon_historical-ssp585_r',num2str(m),'i1p1f1_pr_gn_1985-2014.nc'],'pr',[1,1,i],[Inf Inf Inf],[1 1 12]),3) * 86400;
    end
    Pbase1 = repmat(month_mean,[1,1,30]);
    Pabs = Panom+Pbase1;


    %% Area averaging for precipitation
       % Take subset of lat and long and create 2D grid
    Plat1 = Plat(59:77);
    Plon1 = Plon(21:41);
    [lats1,lons1] = meshgrid(Plat1,Plon1);

    % Subset Precip
    Pabs1 = Pabs(21:41,59:77,:);
    Pbase1 = Pbase(21:41,59:77,:);

    % Create area weighting
    if exist('areas.mat','file')
        load('areas.mat')
    else
        areas = calc_latlon_area(lats1,lons1,'areaquad');
        save('areas.mat','areas')
    end

    % Select just the summer rainfall region
    lons_id = 10:30;
    lats_id = 6:24;
    areas_sub = areas(lons_id,lats_id)./nansum(nansum(areas(lons_id,lats_id)));

    % Create area fraction weighting
    % areas_frac = areas / sum(sum(areas));
    area_frac_all = repmat(areas_sub,1,1,360);

    % Calculate weighted mean time series for each period
    PbaseTS = squeeze(nansum(nansum(Pbase1.*area_frac_all,1),2));
    PabsTS = squeeze(nansum(nansum(Pabs1.*area_frac_all,1),2));
    Mod_P(m,:,1) = PbaseTS;
    Mod_P(m,:,2) = PabsTS;


    %% Take just DJF period

    P_DJF = nan(29,2); % years x time periods
    for i = 1:29
        ids = (i-1)*12+(12:14);
        P_DJF(i,1) = mean(PbaseTS(ids));
        P_DJF(i,2) = mean(PabsTS(ids));
    end


    %% Select months/season for past

    % Select end of SST period
    SST_end = SSTbase(:,:,end-359:end);

    % Calculate SON totals (plus annual and some lags)
    SSTbase_DJF = nan(length(Mlon(:,1)),length(Mlon(1,:)),29,4); % lon x lat x years x time lags
    for i = 1:29
        ids = (i-1)*12+(12);
        SSTbase_DJF(:,:,i,1) = mean(SST_end(:,:,ids),3); % D

        ids = (i-1)*12+(13);
        SSTbase_DJF(:,:,i,2) = mean(SST_end(:,:,ids),3); % J

        ids = (i-1)*12+(14);
        SSTbase_DJF(:,:,i,3) = mean(SST_end(:,:,ids),3); % F

        ids = (i-1)*12+(12:14);
        SSTbase_DJF(:,:,i,4) = mean(SST_end(:,:,ids),3); % DJF

    end


    %% Select months/season for future

    % Select end of SST period
    SST_end = SSTfut(:,:,end-371:end-12);

    % Calculate SON totals (plus annual and some lags)
    SSTfut_DJF = nan(length(Mlon(:,1)),length(Mlon(1,:)),29,5); % lon x lat x years x time lags
    for i = 1:29
        ids = (i-1)*12+(12);
        SSTfut_DJF(:,:,i,1) = mean(SST_end(:,:,ids),3); % D

        ids = (i-1)*12+(13);
        SSTfut_DJF(:,:,i,2) = mean(SST_end(:,:,ids),3); % J

        ids = (i-1)*12+(14);
        SSTfut_DJF(:,:,i,3) = mean(SST_end(:,:,ids),3); % F

        ids = (i-1)*12+(12:14);
        SSTfut_DJF(:,:,i,4) = mean(SST_end(:,:,ids),3); % DJF

    end


%     %% Mask for calculating tropical mean
%     [Plats,Plons] = meshgrid(Plat,Plon);
%     trop_mask = zeros(360,180);
%     trop_mask(:,71:110) = 1;
% 
%     if max(max(Mlon)) <=180
%         Mlon_pos = Mlon;
%         Mlon_pos(Mlon<0) = Mlon_pos(Mlon<0)+360;
%     else
%         Mlon_pos = Mlon;
%     end
% 
%     SSTanom1 = mean(SSTfut_DJF(:,:,:,4),3) - mean(SSTbase_DJF(:,:,:,4),3);
%     SSTanom1 = griddata(Mlon_pos,Mlat,SSTanom1,Plons,Plats,'linear');
%     LSM = ~isnan(SSTanom1);
%     trop_mask_ocean = trop_mask .* LSM;
% 
%     areas = calc_latlon_area(double(Plats),double(Plons),'areaquad');
%     % Create area fraction weighting
%     areas_frac = (areas.*trop_mask_ocean) / nansum(nansum(areas.*trop_mask_ocean));
% 
% %     SSTanom.(models1{m}) = SSTanom1 - nansum(nansum(SSTanom1.*areas_frac));
%     SSTanom_1 = SSTanom1 - nansum(nansum(SSTanom1.*areas_frac));
%     SSTanom_all(:,:,m) = SSTanom_1;


    %% Grid point correlation

    for i = 1:length(Mlon(:,1))
        for j = 1:length(Mlon(1,:))
                [SSTbase_P_corr(i,j,m,1),SSTbase_P_corr(i,j,m,2)] = corr(squeeze(SSTbase_DJF(i,j,:,4)),P_DJF(:,1));
        end
    end

    for i = 1:length(Mlon(:,1))
        for j = 1:length(Mlon(1,:))
                [SSTfut_P_corr(i,j,m,1),SSTfut_P_corr(i,j,m,2)] = corr(squeeze(SSTfut_DJF(i,j,:,4)),P_DJF(:,2));
        end
    end


    %% Plot

    subplot(4,3,m)
    % Set up axes
    axesm('MapProjection','Robinson', 'MapLatLim', latlim,...
        'MapLonLim', lonlim, 'MLineLocation', 15,...
        'PlineLocation', 10, 'MLabelParallel', 'south')

    % Plot the data
    pcolorm(double(Mlat),double(Mlon),SSTbase_P_corr(:,:,m,1))

    % Stippling for low p-values
    mask = SSTbase_P_corr(:,:,m,2) < 0.05;
    for i = 1:6:length(mask(:,1))
        for j = 1:6:length(mask(1,:))
            if mask(i,j) == 1
                plotm(double(Mlat(i,j)),double(Mlon(i,j)),'.','color',[0.35 0.35 0.35])
            end
        end
    end

    % Adjust the plot
    framem('FEdgeColor', 'black', 'FLineWidth', 1)
    gridm('Gcolor',[0.3 0.3 0.3])
    tightmap
    box off
    axis off

    title(['r',num2str(m),'i1p1f1'])
    caxis([-1 1])



    % Add coastline
    hold on
    geoshow([S.Lat], [S.Lon],'Color','black');

    % Add Nino 3.4 region
    plotm([5, 5, 2.5, 0, -2.5  -5, -5, -2.5, 0, 2.5, 5], [-170,-120,-120,-120,-120,-120,-170,-170,-170,-170,-170]  ,'-k')
set(gca,'fontsize',14)
end



%% Plot composite
subplot(4,3,12)

% Set up axes
axesm('MapProjection','Robinson', 'MapLatLim', latlim,...
    'MapLonLim', lonlim, 'MLineLocation', 15,...
    'PlineLocation', 10, 'MLabelParallel', 'south')

% Plot the data
pcolorm(double(Mlat),double(Mlon),mean(SSTbase_P_corr(:,:,:,1),3))

%     % Stippling for low p-values
%     mask = SSTbase_P_corr(:,:,m,2) < 0.05;
%     for i = 1:3:length(mask(:,1))
%         for j = 1:3:length(mask(1,:))
%             if mask(i,j) == 1
%                 plotm(double(Mlat(i,j)),double(Mlon(i,j)),'.','color',[0.35 0.35 0.35])
%             end
%         end
%     end

% Adjust the plot
framem('FEdgeColor', 'black', 'FLineWidth', 1)
gridm('Gcolor',[0.3 0.3 0.3])
tightmap
box off
axis off

title('CanESM5 mean')
caxis([-1 1])
cbh = colorbar;
cbh.Label.String = 'Correlation coefficient';

% Add coastline
hold on
geoshow([S.Lat], [S.Lon],'Color','black');

% Add Nino 3.4 region
plotm([5, 5, 2.5, 0, -2.5  -5, -5, -2.5, 0, 2.5, 5], [-170,-120,-120,-120,-120,-120,-170,-170,-170,-170,-170]  ,'-k')
set(gca,'fontsize',14)

% %% Plot composite
% figure
% set(gcf, 'color', 'w');
% colormap(RBcolgradcon)
% 
% 
% subplot(2,1,1)
% 
% % Set up axes
% axesm('MapProjection','Robinson', 'MapLatLim', latlim,...
%     'MapLonLim', lonlim, 'MLineLocation', 15,...
%     'PlineLocation', 10, 'MLabelParallel', 'south')
% 
% % Plot the data
% pcolorm(double(Plats),double(Plons),mean(SSTanom_all,3))
% 
% % Adjust the plot
% framem('FEdgeColor', 'black', 'FLineWidth', 1)
% gridm('Gcolor',[0.3 0.3 0.3])
% tightmap
% box off
% axis off
% 
% title('CanESM5 mean')
% caxis([-2 2])
% cbh2 = colorbar;
% cbh2.Label.String = 'SST change (°C)';
% 
% % Add coastline
% hold on
% geoshow([S.Lat], [S.Lon],'Color','black');
% 
% % Add Nino 3.4 region
% plotm([5, 5, 2.5, 0, -2.5  -5, -5, -2.5, 0, 2.5, 5], [-170,-120,-120,-120,-120,-120,-170,-170,-170,-170,-170]  ,'-k')
% 
% subplot(2,1,2)
% 
% % Set up axes
% axesm('MapProjection','Robinson', 'MapLatLim', latlim,...
%     'MapLonLim', lonlim, 'MLineLocation', 15,...
%     'PlineLocation', 10, 'MLabelParallel', 'south')
% 
% % Plot the data
% pcolorm(double(Plats),double(Plons),abs(mean(SSTanom_all,3))./std(SSTanom_all,[],3))
% 
% % Adjust the plot
% framem('FEdgeColor', 'black', 'FLineWidth', 1)
% gridm('Gcolor',[0.3 0.3 0.3])
% tightmap
% box off
% axis off
% 
% title('CanESM5 mean/standard deviation')
% caxis([0 10])
% cbh2 = colorbar;
% % cbh2.Label.String = 'SST change (z-score)';
% 
% % Add coastline
% hold on
% geoshow([S.Lat], [S.Lon],'Color','black');
% 
% % Add Nino 3.4 region
% plotm([5, 5, 2.5, 0, -2.5  -5, -5, -2.5, 0, 2.5, 5], [-170,-120,-120,-120,-120,-120,-170,-170,-170,-170,-170]  ,'-k')
% 
% 
% % %% Rename variable for plotting later
% % SSTanom_all_dry = SSTanom_all;
