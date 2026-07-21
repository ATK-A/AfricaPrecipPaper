%% Load climate model data processed by ESMValTool
% Directory paths to all required files, pre-processed by ESMValTool
files_6janE = dir('../ESMValTool/output/long_variability/CMIP6_jan_east/*.nc');
files_5janE = dir('../ESMValTool/output/long_variability/CMIP5_jan_east/*.nc');
files_6febE = dir('../ESMValTool/output/long_variability/CMIP6_feb_east/*.nc');
files_5febE = dir('../ESMValTool/output/long_variability/CMIP5_feb_east/*.nc');
files_6decE = dir('../ESMValTool/output/long_variability/CMIP6_dec_east/*.nc');
files_5decE = dir('../ESMValTool/output/long_variability/CMIP5_dec_east/*.nc');

files_6janW = dir('../ESMValTool/output/long_variability/CMIP6_jan_west/*.nc');
files_5janW = dir('../ESMValTool/output/long_variability/CMIP5_jan_west/*.nc');
files_6febW = dir('../ESMValTool/output/long_variability/CMIP6_feb_west/*.nc');
files_5febW = dir('../ESMValTool/output/long_variability/CMIP5_feb_west/*.nc');
files_6decW = dir('../ESMValTool/output/long_variability/CMIP6_dec_west/*.nc');
files_5decW = dir('../ESMValTool/output/long_variability/CMIP5_dec_west/*.nc');

% Create empty arrays to fill
Pchange_seas = nan(length(files_6janE) + length(files_5janE),180,2);

% First, load CMIP6
for i = 1:length(files_6janE)

    % Seasonal data
    filea = [files_6decE(i).folder,'/',files_6decE(i).name];
    fileb = [files_6janE(i).folder,'/',files_6janE(i).name];
    filec = [files_6febE(i).folder,'/',files_6febE(i).name];
    Pchange_seas(i,:,1) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);
    % Seasonal data
    filea = [files_6decW(i).folder,'/',files_6decW(i).name];
    fileb = [files_6janW(i).folder,'/',files_6janW(i).name];
    filec = [files_6febW(i).folder,'/',files_6febW(i).name];
    Pchange_seas(i,:,2) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);

end

% Next, load CMIP5
for i = 1:length(files_5janE)

    % Seasonal data
    filea = [files_5decE(i).folder,'/',files_5decE(i).name];
    fileb = [files_5janE(i).folder,'/',files_5janE(i).name];
    filec = [files_5febE(i).folder,'/',files_5febE(i).name];
    Pchange_seas(i+length(files_6janE),:,1) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);
    % Seasonal data
    filea = [files_5decW(i).folder,'/',files_5decW(i).name];
    fileb = [files_5janW(i).folder,'/',files_5janW(i).name];
    filec = [files_5febW(i).folder,'/',files_5febW(i).name];
    Pchange_seas(i+length(files_6janE),:,2) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);

end


%% Warming stripes style
Pchange_all = Pchange_seas(:,1:179,:);

load('filenames.mat')
load('BrBG22.mat')
regions = {'(d) Eastern DJF','(e) Western DJF'};

for k = 1:2
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
plot(X.*isnan(Z2)+0.5,Y.*isnan(Z2)+0.5,'x','color', [0.35 0.35 0.35])

cbar = colorbar('Position',[0.87 0.25 0.025 0.5]);
ylabel(cbar,'Precipitation anomaly (mm)','fontsize',16)
cbar.FontSize = 14;
f1 = gca;
f1.XAxis.FontSize = 14;

title(regions(k),'fontsize',16)
end


%% To save:
% print('East_DJF_stripes','-dpdf','-fillpage')
% print('West_DJF_stripes','-dpdf','-fillpage')
