

figure
load('RBcolgradcon.mat')
set(gcf, 'color', 'w');
colormap(RBcolgradcon)
% Coastline
S = shaperead('landareas','UseGeoCoords',true);

% lat-long limits for plotting
latlim = [-90 90];
lonlim = [-180 180];

% models = {'ACCESS-ESM1-5','CanESM5','CNRM-ESM2-1','IPSL-CM6A-LR','GISS-E2-1-G','NorESM2-MM','UKESM1-0-LL'};
models = {'ACCESS-ESM1-5','CNRM-ESM2-1','IPSL-CM6A-LR','GISS-E2-1-G','NorESM2-MM','UKESM1-0-LL'};
% models1 = {'ACCESS_ESM1_5','CanESM5','CNRM_ESM2_1','IPSL_CM6A_LR','GISS_E2_1_G','NorESM2_MM','UKESM1_0_LL'};
models1 = {'ACCESS_ESM1_5','CNRM_ESM2_1','IPSL_CM6A_LR','GISS_E2_1_G','NorESM2_MM','UKESM1_0_LL'};

Nino34 = nan(6,360,2); % models x months x time periods

for m = 1:6
    %% Load data

    if m == 1
        % SST data & lat/long
        % SST data
        disp(['Loading ',string(models(m))])
        SSTbase = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_ACCESS-ESM1-5_historical_r1i1p1f1_gn_185001-201412.nc','tos');
        SSTfut = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_ACCESS-ESM1-5_ssp585_r1i1p1f1_gn_201501-210012.nc','tos');
        Mlon = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_ACCESS-ESM1-5_ssp585_r1i1p1f1_gn_201501-210012.nc','longitude');
        Mlat = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_ACCESS-ESM1-5_ssp585_r1i1p1f1_gn_201501-210012.nc','latitude');

        % Precip data (all months)
        Panom = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_ACCESS-ESM1-5_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2099.nc','pr') * 86400;
        Pbase = ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_ACCESS-ESM1-5_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2014.nc','pr') * 86400;
        Plon = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_ACCESS-ESM1-5_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2099.nc','lon');
        Plat = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_ACCESS-ESM1-5_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2099.nc','lat');

        % Need monthly mean for baseline
        month_mean = nan(length(Plon(:,1)),length(Plat(:,1)),12);
        for i = 1:12
            month_mean(:,:,i) = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_ACCESS-ESM1-5_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2014.nc','pr',[1,1,i],[Inf Inf Inf],[1 1 12]),3) * 86400;
        end
        Pbase1 = repmat(month_mean,[1,1,30]);
        Pabs = Panom+Pbase1;

%     elseif m == 2
%         % SST data & lat/long
%         disp(['Loading ',string(models(m))])
%         SSTbase = ncread('CMIP6_SSP585/tos_Omon_CanESM5_historical_r1i1p1f1_gn_185001-201412.nc','tos');
%         SSTfut = ncread('CMIP6_SSP585/tos_Omon_CanESM5_ssp585_r1i1p1f1_gn_201501-210012.nc','tos');
%         Mlon = ncread('CMIP6_SSP585/tos_Omon_CanESM5_ssp585_r1i1p1f1_gn_201501-210012.nc','longitude');
%         Mlat = ncread('CMIP6_SSP585/tos_Omon_CanESM5_ssp585_r1i1p1f1_gn_201501-210012.nc','latitude');
% 
%         % Precip data (all months)
%         Panom = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_CanESM5_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2099.nc','pr') * 86400;
%         Pbase = ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_CanESM5_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2014.nc','pr') * 86400;
%         %         Pbase1 = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_CanESM5_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2014.nc','pr'),3) * 86400;
%         %         Pabs = Panom+Pbase1;
%         Plon = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_CanESM5_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2099.nc','lon');
%         Plat = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_CanESM5_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2099.nc','lat');
% 
%         % Need monthly mean for baseline
%         month_mean = nan(length(Plon(:,1)),length(Plat(:,1)),12);
%         for i = 1:12
%             month_mean(:,:,i) = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_CanESM5_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2014.nc','pr',[1,1,i],[Inf Inf Inf],[1 1 12]),3) * 86400;
%         end
%         Pbase1 = repmat(month_mean,[1,1,30]);
%         Pabs = Panom+Pbase1;


    elseif m == 2
        disp(['Loading ',string(models(m))])
        % SST data & lat/long
        SSTbase = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_CNRM-ESM2-1_historical_r1i1p1f2_gn_185001-201412.nc','tos');
        SSTfut = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_CNRM-ESM2-1_ssp585_r1i1p1f2_gn_201501-210012.nc','tos');
        Mlon = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_CNRM-ESM2-1_historical_r1i1p1f2_gn_185001-201412.nc','lon');
        Mlat = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_CNRM-ESM2-1_historical_r1i1p1f2_gn_185001-201412.nc','lat');

        % Precip data (all months) & lat/long
        Panom = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_CNRM-ESM2-1_Amon_historical-ssp585_r1i1p1f2_pr_gr_1985-2099.nc','pr') * 86400;
        Pbase = ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_CNRM-ESM2-1_Amon_historical-ssp585_r1i1p1f2_pr_gr_1985-2014.nc','pr') * 86400;
        %         Pbase1 = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_CNRM-ESM2-1_Amon_historical-ssp585_r1i1p1f2_pr_gr_1985-2014.nc','pr'),3) * 86400;
        %         Pabs = Panom+Pbase1;
        Plon = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_CNRM-ESM2-1_Amon_historical-ssp585_r1i1p1f2_pr_gr_1985-2099.nc','lon');
        Plat = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_CNRM-ESM2-1_Amon_historical-ssp585_r1i1p1f2_pr_gr_1985-2099.nc','lat');

        % Need monthly mean for baseline
        month_mean = nan(length(Plon(:,1)),length(Plat(:,1)),12);
        for i = 1:12
            month_mean(:,:,i) = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_CNRM-ESM2-1_Amon_historical-ssp585_r1i1p1f2_pr_gr_1985-2014.nc','pr',[1,1,i],[Inf Inf Inf],[1 1 12]),3) * 86400;
        end
        Pbase1 = repmat(month_mean,[1,1,30]);
        Pabs = Panom+Pbase1;


    elseif m == 3
        disp(['Loading ',string(models(m))])
        % SST data & lat/long
        SSTbase = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_IPSL-CM6A-LR_historical_r1i1p1f1_gn_185001-201412.nc','tos');
        SSTfut = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_IPSL-CM6A-LR_ssp585_r1i1p1f1_gn_201501-210012.nc','tos');
        Mlon = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_IPSL-CM6A-LR_ssp585_r1i1p1f1_gn_201501-210012.nc','nav_lon');
        Mlat = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_IPSL-CM6A-LR_ssp585_r1i1p1f1_gn_201501-210012.nc','nav_lat');

        % Precip data (all months) & lat/long
        Panom = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_IPSL-CM6A-LR_Amon_historical-ssp585_r1i1p1f1_pr_gr_1985-2099.nc','pr') * 86400;
        Pbase = ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_IPSL-CM6A-LR_Amon_historical-ssp585_r1i1p1f1_pr_gr_1985-2014.nc','pr') * 86400;
        %         Pbase1 = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_IPSL-CM6A-LR_Amon_historical-ssp585_r1i1p1f1_pr_gr_1985-2014.nc','pr'),3) * 86400;
        %         Pabs = Panom+Pbase1;
        Plon = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_IPSL-CM6A-LR_Amon_historical-ssp585_r1i1p1f1_pr_gr_1985-2099.nc','lon');
        Plat = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_IPSL-CM6A-LR_Amon_historical-ssp585_r1i1p1f1_pr_gr_1985-2099.nc','lat');

        % Need monthly mean for baseline
        month_mean = nan(length(Plon(:,1)),length(Plat(:,1)),12);
        for i = 1:12
            month_mean(:,:,i) = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_IPSL-CM6A-LR_Amon_historical-ssp585_r1i1p1f1_pr_gr_1985-2014.nc','pr',[1,1,i],[Inf Inf Inf],[1 1 12]),3) * 86400;
        end
        Pbase1 = repmat(month_mean,[1,1,30]);
        Pabs = Panom+Pbase1;

    elseif m == 4
        disp(['Loading ',string(models(m))])
        % SST data & lat/long
        SSTbase = cat(3,ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_GISS-E2-1-G_historical_r1i1p1f2_gn_195101-200012.nc','tos'),ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_GISS-E2-1-G_historical_r1i1p1f2_gn_200101-201412.nc','tos'));
        SSTfut = cat(3,ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_GISS-E2-1-G_ssp585_r1i1p1f2_gn_201501-205012.nc','tos'),ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_GISS-E2-1-G_ssp585_r1i1p1f2_gn_205101-210012.nc','tos'));
        Mlon1 = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_GISS-E2-1-G_ssp585_r1i1p1f2_gn_205101-210012.nc','lon');
        Mlat1 = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_GISS-E2-1-G_ssp585_r1i1p1f2_gn_205101-210012.nc','lat');
        [Mlat,Mlon] = meshgrid(Mlat1,Mlon1);

        % Precip data (all months) & lat/long
        Panom = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_GISS-E2-1-G_Amon_historical-ssp585_r1i1p1f2_pr_gn_1985-2099.nc','pr') * 86400;
        Pbase = ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_GISS-E2-1-G_Amon_historical-ssp585_r1i1p1f2_pr_gn_1985-2014.nc','pr') * 86400;
        %         Pbase1 = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_IPSL-CM6A-LR_Amon_historical-ssp585_r1i1p1f1_pr_gr_1985-2014.nc','pr'),3) * 86400;
        %         Pabs = Panom+Pbase1;
        Plon = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_GISS-E2-1-G_Amon_historical-ssp585_r1i1p1f2_pr_gn_1985-2099.nc','lon');
        Plat = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_GISS-E2-1-G_Amon_historical-ssp585_r1i1p1f2_pr_gn_1985-2099.nc','lat');

        % Need monthly mean for baseline
        month_mean = nan(length(Plon(:,1)),length(Plat(:,1)),12);
        for i = 1:12
            month_mean(:,:,i) = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_GISS-E2-1-G_Amon_historical-ssp585_r1i1p1f2_pr_gn_1985-2014.nc','pr',[1,1,i],[Inf Inf Inf],[1 1 12]),3) * 86400;
        end
        Pbase1 = repmat(month_mean,[1,1,30]);
        Pabs = Panom+Pbase1;

    elseif m == 5
        disp(['Loading ',string(models(m))])
        % SST data & lat/long
        SSTbase = cat(3,ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_NorESM2-MM_historical_r1i1p1f1_gn_198001-198912.nc','tos'),ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_NorESM2-MM_historical_r1i1p1f1_gn_199001-199912.nc','tos'),...
            ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_NorESM2-MM_historical_r1i1p1f1_gn_200001-200912.nc','tos'),ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_NorESM2-MM_historical_r1i1p1f1_gn_201001-201412.nc','tos'));
        SSTfut = cat(3,ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_NorESM2-MM_ssp585_r1i1p1f1_gn_206101-207012.nc','tos'),ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_NorESM2-MM_ssp585_r1i1p1f1_gn_207101-208012.nc','tos'),...
            ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_NorESM2-MM_ssp585_r1i1p1f1_gn_208101-209012.nc','tos'),ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_NorESM2-MM_ssp585_r1i1p1f1_gn_209101-210012.nc','tos'));
        Mlon = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_NorESM2-MM_ssp585_r1i1p1f1_gn_209101-210012.nc','longitude');
        Mlat = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_NorESM2-MM_ssp585_r1i1p1f1_gn_209101-210012.nc','latitude');

        % Precip data (all months) & lat/long
        Panom = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_NorESM2-MM_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2099.nc','pr') * 86400;
        Pbase = ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_NorESM2-MM_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2014.nc','pr') * 86400;
        %         Pbase1 = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_IPSL-CM6A-LR_Amon_historical-ssp585_r1i1p1f1_pr_gr_1985-2014.nc','pr'),3) * 86400;
        %         Pabs = Panom+Pbase1;
        Plon = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_NorESM2-MM_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2099.nc','lon');
        Plat = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_NorESM2-MM_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2099.nc','lat');

        % Need monthly mean for baseline
        month_mean = nan(length(Plon(:,1)),length(Plat(:,1)),12);
        for i = 1:12
            month_mean(:,:,i) = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_NorESM2-MM_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2014.nc','pr',[1,1,i],[Inf Inf Inf],[1 1 12]),3) * 86400;
        end
        Pbase1 = repmat(month_mean,[1,1,30]);
        Pabs = Panom+Pbase1;


    elseif m == 6
        % SST data & lat/long
        disp(['Loading ',string(models(m))])
        SSTbase = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_UKESM1-0-LL_historical_r1i1p1f2_gn_195001-201412.nc','tos');
        SSTfut = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_UKESM1-0-LL_ssp585_r1i1p1f2_gn_205001-210012.nc','tos');
        Mlon = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_UKESM1-0-LL_ssp585_r1i1p1f2_gn_205001-210012.nc','longitude');
        Mlat = ncread('/Volumes/DataDrive/CMIP6/tos/tos_Omon_UKESM1-0-LL_ssp585_r1i1p1f2_gn_205001-210012.nc','latitude');

        % Precip data (all months)
        Panom = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_UKESM1-0-LL_Amon_historical-ssp585_r1i1p1f2_pr_gn_1985-2099.nc','pr') * 86400;
        Pbase = ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_UKESM1-0-LL_Amon_historical-ssp585_r1i1p1f2_pr_gn_1985-2014.nc','pr') * 86400;
        %         Pbase1 = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_CanESM5_Amon_historical-ssp585_r1i1p1f1_pr_gn_1985-2014.nc','pr'),3) * 86400;
        %         Pabs = Panom+Pbase1;
        Plon = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_UKESM1-0-LL_Amon_historical-ssp585_r1i1p1f2_pr_gn_1985-2099.nc','lon');
        Plat = ncread('../ESMValTool/output/CMIP6_allmonths/change/CMIP6_UKESM1-0-LL_Amon_historical-ssp585_r1i1p1f2_pr_gn_1985-2099.nc','lat');

        % Need monthly mean for baseline
        month_mean = nan(length(Plon(:,1)),length(Plat(:,1)),12);
        for i = 1:12
            month_mean(:,:,i) = mean(ncread('../ESMValTool/output/CMIP6_allmonths/baseline/CMIP6_UKESM1-0-LL_Amon_historical-ssp585_r1i1p1f2_pr_gn_1985-2014.nc','pr',[1,1,i],[Inf Inf Inf],[1 1 12]),3) * 86400;
        end
        Pbase1 = repmat(month_mean,[1,1,30]);
        Pabs = Panom+Pbase1;


     end


    %% Make longitude -180  to 180
    if sum(sum(Mlon>180))>0
        mask = Mlon>180;
        Mlon(mask) = Mlon(mask)-360;
    end

    %% Area averaging

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

    % %% Area averaging for ENSO index
    % Mlat = double(Mlat);
    % Mlon = double(Mlon);
    % 
    % % Find grid points for corners of Nino 3.4 region
    % [lon1,lat1] = find_location(-170,-5,Mlon,Mlat);
    % [lon2,lat2] = find_location(-120,5,Mlon,Mlat);
    % 
    % 
    % 
    % % Create area fraction weighting
    % areas_34 = calc_latlon_area(Mlat,Mlon,'areaquad');
    % areas_frac = areas_34(lon1:lon2,lat1:lat2) / sum(sum(areas_34(lon1:lon2,lat1:lat2)));
    % area_frac_all = repmat(areas_frac,1,1,360);
    % 
    % % Calculate weighted mean time series for each period
    % Nino34base = squeeze(nansum(nansum(SSTbase(lon1:lon2,lat1:lat2).*area_frac_all,1),2));
    % Nino34fut = squeeze(nansum(nansum(SSTfut(lon1:lon2,lat1:lat2).*area_frac_all,1),2));
    % 
    % Nino34(m,:,1) = Nino34base;
    % Nino34(m,:,2) = Nino34fut;

    %% Take just DJF period

    % % General ID for selecting all SON
    % ids1 = 1:12:349;
    % ids = sort(cat(2,ids1+8,ids1+9,ids1+10));

    % Calculate SON totals
    P_DJF = nan(29,2); % years x time periods
    for i = 1:29
        ids = (i-1)*12+(12:14);
        P_DJF(i,1) = mean(PbaseTS(ids));
        P_DJF(i,2) = mean(PabsTS(ids));
    end



    %% Correlation with SST - past

    % Select end of SST period
    SST_end = SSTbase(:,:,end-359:end);

    % Calculate SON totals (plus annual and some lags)
    SSTbase_DJF = nan(length(Mlon(:,1)),length(Mlon(1,:)),29); % lon x lat x years
    for i = 1:29
        ids = (i-1)*12+(12:14);
        SSTbase_DJF(:,:,i) = mean(SST_end(:,:,ids),3); % DJF
    end

    % Correlate each grid cell
    SSTbase_P_corr = nan(length(Mlon(:,1)),length(Mlon(1,:)),2);

    for i = 1:length(Mlon(:,1))
        for j = 1:length(Mlon(1,:))
                [SSTbase_P_corr(i,j,1),SSTbase_P_corr(i,j,2)] = corr(squeeze(SSTbase_DJF(i,j,:)),P_DJF(:,1));
        end
    end

    %% Correlation with SST - future

    % Select end of SST period
    SST_end = SSTfut(:,:,end-371:end-12);

    % Calculate SON totals (plus annual and some lags)
    SSTfut_DJF = nan(length(Mlon(:,1)),length(Mlon(1,:)),29); % lon x lat x years
    for i = 1:29
        ids = (i-1)*12+(12:14);
        SSTfut_DJF(:,:,i,1) = mean(SST_end(:,:,ids),3); % Annual correlation

    end

    % Correlate each grid cell
    SSTfut_P_corr = nan(length(Mlon(:,1)),length(Mlon(1,:)),2);

    for i = 1:length(Mlon(:,1))
        for j = 1:length(Mlon(1,:))
                [SSTfut_P_corr(i,j,1),SSTfut_P_corr(i,j,2)] = corr(squeeze(SSTfut_DJF(i,j,:)),P_DJF(:,2));
        end
    end


    %% Store output
    % Corr_base.(string(models1(m))) = SSTbase_P_corr;
    % Corr_future.(string(models1(m))) = SSTfut_P_corr;

    Corr_base.(string(models1(m))) = SSTbase_P_corr;
    Corr_future.(string(models1(m))) = SSTfut_P_corr;

    Lat.(string(models1(m))) = double(Mlat);
    Lon.(string(models1(m))) = double(Mlon);


    %% Plot


    subplot(3,4,1+(m-1)*2)
%     subplot(7,2,1+(m-1)*2)
%     subplot(1,2,1)

    % Set up axes
    axesm('MapProjection','Robinson', 'MapLatLim', latlim,...
        'MapLonLim', lonlim, 'MLineLocation', 15,...
        'PlineLocation', 10, 'MLabelParallel', 'south')

    % Plot the data
    pcolorm(double(Mlat),double(Mlon),SSTbase_P_corr(:,:,1))

    % Adjust the plot
    framem('FEdgeColor', 'black', 'FLineWidth', 1)
    gridm('Gcolor',[0.3 0.3 0.3])
    tightmap
    box off
    axis off

    title(['Past ',models(m)])
    caxis([-1 1])

    % Add coastline
    hold on
    geoshow([S.Lat], [S.Lon],'Color','black');



    % Stippling for low p-values
    mask = SSTbase_P_corr(:,:,2) < 0.05;
    for i = 1:5:length(mask(:,1))
        for j = 1:5:length(mask(1,:))
            if mask(i,j) == 1
                plotm(double(Mlat(i,j)),double(Mlon(i,j)),'.','color',[0.35 0.35 0.35])
            end
        end
    end

    % Add Nino 3.4 region
    plotm([5, 5, 2.5, 0, -2.5  -5, -5, -2.5, 0, 2.5, 5], [-170,-120,-120,-120,-120,-120,-170,-170,-170,-170,-170]  ,'-k')
set(gca,'fontsize',14)

%     subplot(1,2,2)
    subplot(3,4,2+(m-1)*2)

    % Set up axes
    axesm('MapProjection','Robinson', 'MapLatLim', latlim,...
        'MapLonLim', lonlim, 'MLineLocation', 15,...
        'PlineLocation', 10, 'MLabelParallel', 'south')

    % Plot the data
    pcolorm(double(Mlat),double(Mlon),SSTfut_P_corr(:,:,1))

    % Adjust the plot
    framem('FEdgeColor', 'black', 'FLineWidth', 1)
    gridm('Gcolor',[0.3 0.3 0.3])
    tightmap
    box off
    axis off

    title(['Future ',models(m)])
    caxis([-1 1])

    % Add coastline
    hold on
    geoshow([S.Lat], [S.Lon],'Color','black');


    % Stippling for low p-values
    mask = SSTfut_P_corr(:,:,2) < 0.05;
    for i = 1:5:length(mask(:,1))
        for j = 1:5:length(mask(1,:))
            if mask(i,j) == 1
                plotm(double(Mlat(i,j)),double(Mlon(i,j)),'.','color',[0.35 0.35 0.35])
            end
        end
    end

    % Add Nino 3.4 region
    plotm([5, 5, 2.5, 0, -2.5  -5, -5, -2.5, 0, 2.5, 5], [-170,-120,-120,-120,-120,-120,-170,-170,-170,-170,-170]  ,'-k')
set(gca,'fontsize',14)
end
cbh = colorbar;
cbh.Label.String = 'Correlation coefficient';




