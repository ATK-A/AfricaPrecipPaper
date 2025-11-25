%% Create Figure 6 and Supplementary Figure 14

%% Load climate model data processed by ESMValTool
% Directory paths to all required files, pre-processed by ESMValTool
files_6jan = dir('../ESMValTool/output/long_variability/CMIP6_jan_large/*.nc');
files_5jan = dir('../ESMValTool/output/long_variability/CMIP5_jan_large/*.nc');
files_6feb = dir('../ESMValTool/output/long_variability/CMIP6_feb_large/*.nc');
files_5feb = dir('../ESMValTool/output/long_variability/CMIP5_feb_large/*.nc');
files_6mar = dir('../ESMValTool/output/long_variability/CMIP6_mar_large/*.nc');
files_5mar = dir('../ESMValTool/output/long_variability/CMIP5_mar_large/*.nc');
files_6apr = dir('../ESMValTool/output/long_variability/CMIP6_apr_large/*.nc');
files_5apr = dir('../ESMValTool/output/long_variability/CMIP5_apr_large/*.nc');
files_6may = dir('../ESMValTool/output/long_variability/CMIP6_may_large/*.nc');
files_5may = dir('../ESMValTool/output/long_variability/CMIP5_may_large/*.nc');
files_6jun = dir('../ESMValTool/output/long_variability/CMIP6_jun_large/*.nc');
files_5jun = dir('../ESMValTool/output/long_variability/CMIP5_jun_large/*.nc');
files_6jul = dir('../ESMValTool/output/long_variability/CMIP6_jul_large/*.nc');
files_5jul = dir('../ESMValTool/output/long_variability/CMIP5_jul_large/*.nc');
files_6aug = dir('../ESMValTool/output/long_variability/CMIP6_aug_large/*.nc');
files_5aug = dir('../ESMValTool/output/long_variability/CMIP5_aug_large/*.nc');
files_6sep = dir('../ESMValTool/output/long_variability/CMIP6_sep_large/*.nc');
files_5sep = dir('../ESMValTool/output/long_variability/CMIP5_sep_large/*.nc');
files_6oct = dir('../ESMValTool/output/long_variability/CMIP6_oct_large/*.nc');
files_5oct = dir('../ESMValTool/output/long_variability/CMIP5_oct_large/*.nc');
files_6nov = dir('../ESMValTool/output/long_variability/CMIP6_nov_large/*.nc');
files_5nov = dir('../ESMValTool/output/long_variability/CMIP5_nov_large/*.nc');
files_6dec = dir('../ESMValTool/output/long_variability/CMIP6_dec_large/*.nc');
files_5dec = dir('../ESMValTool/output/long_variability/CMIP5_dec_large/*.nc');

% Create empty arrays to fill
Pchange_seas = nan(length(files_6jan) + length(files_5jan),180,4);

% First, load CMIP6
for i = 1:length(files_6jan)
    % Seasonal data
    filea = [files_6dec(i).folder,'/',files_6dec(i).name];
    fileb = [files_6jan(i).folder,'/',files_6jan(i).name];
    filec = [files_6feb(i).folder,'/',files_6feb(i).name];
    Pchange_seas(i,:,1) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);
    filea = [files_6mar(i).folder,'/',files_6mar(i).name];
    fileb = [files_6apr(i).folder,'/',files_6apr(i).name];
    filec = [files_6may(i).folder,'/',files_6may(i).name];
    Pchange_seas(i,:,2) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);
    filea = [files_6jun(i).folder,'/',files_6jun(i).name];
    fileb = [files_6jul(i).folder,'/',files_6jul(i).name];
    filec = [files_6aug(i).folder,'/',files_6aug(i).name];
    Pchange_seas(i,:,3) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);
    filea = [files_6sep(i).folder,'/',files_6sep(i).name];
    fileb = [files_6oct(i).folder,'/',files_6oct(i).name];
    filec = [files_6nov(i).folder,'/',files_6nov(i).name];
    Pchange_seas(i,:,4) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);

end

% Next, load CMIP5
for i = 1:length(files_5jan)
    % Seasonal data
    filea = [files_5dec(i).folder,'/',files_5dec(i).name];
    fileb = [files_5jan(i).folder,'/',files_5jan(i).name];
    filec = [files_5feb(i).folder,'/',files_5feb(i).name];
    Pchange_seas(i+length(files_6jan),:,1) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);
    filea = [files_5mar(i).folder,'/',files_5mar(i).name];
    fileb = [files_5apr(i).folder,'/',files_5apr(i).name];
    filec = [files_5may(i).folder,'/',files_5may(i).name];
    Pchange_seas(i+length(files_6jan),:,2) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);
    filea = [files_5jun(i).folder,'/',files_5jun(i).name];
    fileb = [files_5jul(i).folder,'/',files_5jul(i).name];
    filec = [files_5aug(i).folder,'/',files_5aug(i).name];
    Pchange_seas(i+length(files_6jan),:,3) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);
    filea = [files_5sep(i).folder,'/',files_5sep(i).name];
    fileb = [files_5oct(i).folder,'/',files_5oct(i).name];
    filec = [files_5nov(i).folder,'/',files_5nov(i).name];
    Pchange_seas(i+length(files_6jan),:,4) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);

end

Pchange_all = Pchange_seas(:,1:179,:);

%% Warming stripes style

load('filenames.mat')
load('BrBG22.mat')
regions = {' ','(c) MAM','(a) JJA',' (b) SON'};

% For main text figure
for k = 1
figure;
set(gcf, 'color', 'w');

% First, CMIP6
subplot('position',[0.11 0.075 0.35 0.9])
Z = nan(95,66);
Z(1:94,1:65) = Pchange_all(1:94,115:179,k);
[X,Y] = meshgrid(2025:2090,1:95);
Z2 = Z;

    for i = 1:94 % Go through each CMIP6 model
        hist_min = min(Pchange_all(i,1:100,k));
        hist_max = max(Pchange_all(i,1:100,k));
        % hist_min = min(Pchange_all(i,1:114,k));
        % hist_max = max(Pchange_all(i,1:114,k));

        for j = 115:179 % Go through each future year
            if Pchange_all(i,j,k) <= hist_max && Pchange_all(i,j,k) >= hist_min
                Z2(i,j-114) = nan;
            end
        end
    end

cols1 = pcolor(X,Y,Z);
% set(cols1,'facealpha',0.5)
set(cols1, 'EdgeColor', 'none');

hold on
cols2 = pcolor(X,Y,Z2);
set(cols2, 'EdgeColor', 'none');
% axis equal
% box on

set(gca,'fontsize',18)
yticks([])
% yticks(1.5:1:94.5)
% yticklabels(filenames(1:94))
colormap(BrBG22)
caxis([-1.1 1.1])
plot(X.*isnan(Z2)+0.5,Y.*isnan(Z2)+0.5,'x','color', [0.15 0.15 0.15],'markersize',9)
f1 = gca;
f1.XAxis.FontSize = 18;
f1.YAxis.FontSize = 9;
title('CMIP6 models')


% Next, CMIP5 models
subplot('position',[0.55 0.075 0.35 0.9])
Z = nan(85,66);
Z(1:84,1:65) = Pchange_all(95:end,115:179,k);
[X,Y] = meshgrid(2025:2090,1:85);
Z2 = Z;

    for i = 1:84 % Go through each model
        hist_min = min(Pchange_all(i+94,1:100,k));
        hist_max = max(Pchange_all(i+94,1:100,k));
        % hist_min = min(Pchange_all(i+94,1:114,k));
        % hist_max = max(Pchange_all(i+94,1:114,k));

        for j = 115:179 % Go through each future year
            if Pchange_all(i+94,j,k) <= hist_max && Pchange_all(i+94,j,k) >= hist_min
                Z2(i,j-114) = nan;
            end
        end
    end

cols1 = pcolor(X,Y,Z);
% set(cols1,'facealpha',0.5)
set(cols1, 'EdgeColor', 'none');

hold on
cols2 = pcolor(X,Y,Z2);
set(cols2, 'EdgeColor', 'none');
% axis equal
% box on
set(gca,'fontsize',18)

yticks([])
% yticks(1.5:1:178.5)
% yticklabels(filenames(95:end))
colormap(BrBG22)
caxis([-1.1 1.1])
plot(X.*isnan(Z2)+0.5,Y.*isnan(Z2)+0.5,'x','color', [0.15 0.15 0.15],'markersize',9)
title('CMIP5 models')
cbar = colorbar('Position',[0.93 0.25 0.02 0.5]);
ylabel(cbar,'Precipitation anomaly (mm)','fontsize',24)
cbar.FontSize = 18;
f1 = gca;
f1.XAxis.FontSize = 18;
f1.YAxis.FontSize = 9;




end

% For supplementary figures
for k = 2:4
figure;
set(gcf, 'color', 'w');
subplot('position',[0.25 0.075 0.6 0.9])
Z = nan(179,66);
Z(1:178,1:65) = Pchange_all(:,115:179,k);
[X,Y] = meshgrid(2025:2090,1:179);
Z2 = Z;

    for i = 1:178 % Go through each model
        hist_min = min(Pchange_all(i,1:100,k));
        hist_max = max(Pchange_all(i,1:100,k));

        for j = 115:179 % Go through each future year
            if Pchange_all(i,j,k) <= hist_max && Pchange_all(i,j,k) >= hist_min
                Z2(i,j-114) = nan;
            end
        end
    end

cols1 = pcolor(X,Y,Z);
% set(cols1,'facealpha',0.5)
set(cols1, 'EdgeColor', 'none');

hold on
cols2 = pcolor(X,Y,Z2);
set(cols2, 'EdgeColor', 'none');
% axis equal
% box on

set(gca,'fontsize',5)
yticks(1.5:1:178.5)
yticklabels(filenames)
colormap(BrBG22)
caxis([-1.1 1.1])
plot(X.*isnan(Z2)+0.5,Y.*isnan(Z2)+0.5,'x','color', [0.15 0.15 0.15])

cbar = colorbar('Position',[0.87 0.25 0.025 0.5]);
ylabel(cbar,'Precipitation anomaly (mm)','fontsize',16)
cbar.FontSize = 14;
f1 = gca;
f1.XAxis.FontSize = 14;

title(regions(k),'fontsize',16)
end




%% To save:
% print('Large_DJF_stripes_revised','-dpdf','-fillpage')
% print('Large_MAM_stripes','-dpdf','-fillpage')
% print('Large_JJA_stripes','-dpdf','-fillpage')
% print('Large_SON_stripes','-dpdf','-fillpage')
