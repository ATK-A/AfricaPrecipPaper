%% Load some basics for plotting
S = shaperead('landareas','UseGeoCoords',true);

% lat-long limits for plotting
latlim = [-90 90];
lonlim = [-180 180];

load('RBcolgradcon.mat')

%% Load data
load('P_CRU_mean_DJF.mat') % Created by ../Precipitation/P_DJF_longterm
load('P_GPCC_mean_DJF.mat') % Created by ../Precipitation/P_DJF_longterm

% Note: this is a land-area average for the summer rainfall region

% SST data
SST_obs_all = ncread('../SST analysis/HadSST.4.1.0.0_actuals_median.nc','tos',[1,1,613],[Inf, Inf, 1440]); % 1901 -> 2020
Slon = ncread('../SST analysis/HadSST.4.1.0.0_actuals_median.nc','longitude');
Slat = ncread('../SST analysis/HadSST.4.1.0.0_actuals_median.nc','latitude');
SST_obs_seas = nan(72,36,119);

SST_obs = SST_obs_all;
SST_obs(SST_obs_all > 100) = nan;

% Calculate for Nov - Feb
    for i = 1:119
        ids = (i-1)*12+(12:14);

        SST_obs_seas(:,:,i) = mean(SST_obs(:,:,ids),3);
    end

[Slats,Slons] = meshgrid(Slat,Slon);


%% Detrend SSTs
% Last 60 years
SST_obs_seas_detrend_60s = nan(72,36,60);
for i = 1:72
    for j = 1:36
        SST_obs_seas_detrend_60s(i,j,:) = detrend(squeeze(SST_obs_seas(i,j,60:end)),'omitnan');
    end
end


%% Detrend precipitation
% Last 60 years
P_obs_seas_detrend_60s = nan(60,2);
P_obs_seas_detrend_60s(:,1) = detrend(squeeze(P_CRU_mean_DJF(60:end)),'omitnan');
P_obs_seas_detrend_60s(:,2) = detrend(squeeze(P_GPCC_mean_DJF(60:end)),'omitnan');


%% Calculate correlation (raw)
% Correlate each grid cell
SST_P_corr = nan(72,36,2);
SST_P_corr_p = nan(72,36,2);

for i = 1:72
    for j = 1:36
            [SST_P_corr(i,j,1),SST_P_corr_p(i,j,1)] = corr(squeeze(SST_obs_seas(i,j,:)),P_CRU_mean_DJF(:), 'rows','complete');
            [SST_P_corr(i,j,1),SST_P_corr_p(i,j,1)] = corr(squeeze(SST_obs_seas(i,j,:)),P_GPCC_mean_DJF(:), 'rows','complete');
    end
end

% Correlate each grid cell
SST_P_corr_60s = nan(72,36,2);
SST_P_corr_p_60s = nan(72,36,2);

for i = 1:72
    for j = 1:36
            [SST_P_corr_60s(i,j,1),SST_P_corr_p_60s(i,j,1)] = corr(squeeze(SST_obs_seas(i,j,60:end)),P_CRU_mean_DJF(60:end), 'rows','complete');
            [SST_P_corr_60s(i,j,2),SST_P_corr_p_60s(i,j,2)] = corr(squeeze(SST_obs_seas(i,j,60:end)),P_GPCC_mean_DJF(60:end), 'rows','complete');
    end
end


%% Calculate correlation (detrended)
% Correlate each grid cell
SST_P_corr_60s_detrend = nan(72,36,2);
SST_P_corr_p_60s_detrend = nan(72,36,2);

for i = 1:72
    for j = 1:36
            [SST_P_corr_60s_detrend(i,j,1),SST_P_corr_p_60s_detrend(i,j,1)] = corr(squeeze(SST_obs_seas_detrend_60s(i,j,:)),P_obs_seas_detrend_60s(:,1), 'rows','complete');
            [SST_P_corr_60s_detrend(i,j,2),SST_P_corr_p_60s_detrend(i,j,2)] = corr(squeeze(SST_obs_seas_detrend_60s(i,j,:)),P_obs_seas_detrend_60s(:,2), 'rows','complete');
    end
end


%% Plot last 60 years only with p values (raw)

latlim=[-90 90];
lonlim=[-180 180];

figure
set(gcf, 'color', 'w');
colormap(RBcolgradcon)
titles = {'(a) CRU raw','(b) CRU detrended','(c) GPCC raw','(d) GPCC detrended'};


% Set some values for indexing through array in loop
dataset = 1;
for p = 1:4

    % Select between raw/detrended data
    if rem(p, 2) == 0
        data = SST_P_corr_60s_detrend;
        data_p = SST_P_corr_p_60s_detrend;
    else
        data = SST_P_corr_60s;
        data_p = SST_P_corr_p_60s;
    end


    subplot(2,2,p)


    set(gca,'fontsize',14)

    % Set up axes
    axesm('MapProjection','Robinson', 'MapLatLim', latlim,...
        'MapLonLim', lonlim, 'MLineLocation', 15,...
        'PlineLocation', 10, 'MLabelParallel', 'south')
    % Plot the data
    pcolorm(double(Slats),double(Slons),data(:,:,dataset))
    % Adjust the plot
    framem('FEdgeColor', 'black', 'FLineWidth', 1)
    gridm('Gcolor',[0.3 0.3 0.3])
    tightmap
    box off
    axis off
    title(titles{p})
    caxis([-1 1])
    % Add coastline
    hold on
    geoshow([S.Lat], [S.Lon],'Color','black');

    % Stippling for low p-values
    mask = data_p(:,:,dataset) < 0.05;
    for i = 1:length(mask(:,1))
        for j = 1:length(mask(1,:))
            if mask(i,j) == 1
                plotm(double(Slats(i,j)),double(Slons(i,j)),'.','color',[0.35 0.35 0.35])
            end
        end
    end

    % Add Nino 3.4 region
    plotm([5, 5, 2.5, 0, -2.5  -5, -5, -2.5, 0, 2.5, 5], [-170,-120,-120,-120,-120,-120,-170,-170,-170,-170,-170]  ,'-k')


    % For next loop iteration swap between CRU/GPCC
    if rem(p, 2) == 0 
        if dataset == 1
            dataset = 2;
        else
            dataset = 1;
        end
    end

set(gca,'fontsize',14)

end


cbh = colorbar;
cbh.Label.String = 'Correlation coefficient';





