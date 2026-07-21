%% Load climate model data processed by ESMValTool
% Directory paths to all required files, pre-processed by ESMValTool
files_6l = dir('../ESMValTool/output/long_variability/CMIP6_large/*.nc');
files_5l = dir('../ESMValTool/output/long_variability/CMIP5_large/*.nc');
files_6u = dir('../ESMValTool/output/long_variability/CMIP6_unc/*.nc');
files_5u = dir('../ESMValTool/output/long_variability/CMIP5_unc/*.nc');
files_6e = dir('../ESMValTool/output/long_variability/CMIP6_east/*.nc');
files_5e = dir('../ESMValTool/output/long_variability/CMIP5_east/*.nc');
files_6w = dir('../ESMValTool/output/long_variability/CMIP6_west/*.nc');
files_5w = dir('../ESMValTool/output/long_variability/CMIP5_west/*.nc');
files_6s = dir('../ESMValTool/output/long_variability/CMIP6_small/*.nc');
files_5s = dir('../ESMValTool/output/long_variability/CMIP5_small/*.nc');
files11a = dir('../ESMValTool/output/long_variability/CMIP6_oct/*.nc');
files12a = dir('../ESMValTool/output/long_variability/CMIP5_oct/*.nc');
files11b = dir('../ESMValTool/output/long_variability/CMIP6_nov/*.nc');
files12b = dir('../ESMValTool/output/long_variability/CMIP5_nov/*.nc');
files11c = dir('../ESMValTool/output/long_variability/CMIP6_dec/*.nc');
files12c = dir('../ESMValTool/output/long_variability/CMIP5_dec/*.nc');
files11d = dir('../ESMValTool/output/long_variability/CMIP6_jan/*.nc');
files12d = dir('../ESMValTool/output/long_variability/CMIP5_jan/*.nc');
files11e = dir('../ESMValTool/output/long_variability/CMIP6_feb/*.nc');
files12e = dir('../ESMValTool/output/long_variability/CMIP5_feb/*.nc');

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
Pchange = nan(length(files_6l) + length(files_5l),2149,5);
Pchange_seas = nan(length(files_6l) + length(files_5l),180,4);

% First, load CMIP6
for i = 1:length(files_6l)
    % Annual data
    file = [files_6l(i).folder,'/',files_6l(i).name];
    Pchange(i,:,1) = ncread(file,'pr')* 86400;
    file = [files_6u(i).folder,'/',files_6u(i).name];
    Pchange(i,:,2) = ncread(file,'pr')* 86400;
    file = [files_6e(i).folder,'/',files_6e(i).name];
    Pchange(i,:,3) = ncread(file,'pr')* 86400;
    file = [files_6w(i).folder,'/',files_6w(i).name];
    Pchange(i,:,4) = ncread(file,'pr')* 86400;
    file = [files_6s(i).folder,'/',files_6s(i).name];
    Pchange(i,:,5) = ncread(file,'pr')* 86400;

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
for i = 1:length(files_5l)
    % Annual data
    file = [files_5l(i).folder,'/',files_5l(i).name];
    Pchange(i+length(files_6l),:,1) = ncread(file,'pr')* 86400;
    file = [files_5u(i).folder,'/',files_5u(i).name];
    Pchange(i+length(files_6l),:,2) = ncread(file,'pr')* 86400;
    file = [files_5e(i).folder,'/',files_5e(i).name];
    Pchange(i+length(files_6l),:,3) = ncread(file,'pr')* 86400;
    file = [files_5w(i).folder,'/',files_5w(i).name];
    Pchange(i+length(files_6l),:,4) = ncread(file,'pr')* 86400;
    file = [files_5s(i).folder,'/',files_5s(i).name];
    Pchange(i+length(files_6l),:,5) = ncread(file,'pr')* 86400;

    % Seasonal data
    filea = [files_5dec(i).folder,'/',files_5dec(i).name];
    fileb = [files_5jan(i).folder,'/',files_5jan(i).name];
    filec = [files_5feb(i).folder,'/',files_5feb(i).name];
    Pchange_seas(i+length(files_6l),:,4) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);
    filea = [files_5mar(i).folder,'/',files_5mar(i).name];
    fileb = [files_5apr(i).folder,'/',files_5apr(i).name];
    filec = [files_5may(i).folder,'/',files_5may(i).name];
    Pchange_seas(i+length(files_6l),:,1) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);
    filea = [files_5jun(i).folder,'/',files_5jun(i).name];
    fileb = [files_5jul(i).folder,'/',files_5jul(i).name];
    filec = [files_5aug(i).folder,'/',files_5aug(i).name];
    Pchange_seas(i+length(files_6l),:,2) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);
    filea = [files_5sep(i).folder,'/',files_5sep(i).name];
    fileb = [files_5oct(i).folder,'/',files_5oct(i).name];
    filec = [files_5nov(i).folder,'/',files_5nov(i).name];
    Pchange_seas(i+length(files_6l),:,3) = mean([ncread(filea,'pr')* 86400,ncread(fileb,'pr')* 86400,ncread(filec,'pr')* 86400],2);

end


%% Calculate annual mean values for easier comparison
Pchange_ann = nan(178,179,5);
for i = 1:179
    ids = 1 + (i-1)*12:12 + (i-1)*12;
    Pchange_ann(:,i,:) = mean(Pchange(:,ids,:),2);
end

Pchange_all = cat(3,Pchange_ann,Pchange_seas(:,1:179,:));


%% Detrend
% Combine the annual data with the monthly data
% Pchange_all = cat(3,Pchange_ann,Pchange_OND(:,1:179));

if ~exist('P_means','var')
    obs_longterm_variability
end

% First, detrend
Detrended = nan(178,100,4); % model x year x season
Detrended_obs = nan(2,100,4); % GPCC/CRU x year x season

for j = 1:4 % Go through each region/season
    for i = 1:178 % Go through each model
        valsy = Pchange_all(i,1:100,j+5); % j+5 as first 5 are annual for different regions
        p1 = polyfit(1911:2010,valsy,1); % Use first order polynomial
        x1 = 1911:2010;
        y1 = polyval(p1,x1);
        Detrended(i,:,j) = valsy - y1;
    end

    % Also repeat for observations
    for i = 1:2
        valsy = mean(P_means(2:101,j,i+2),3);
        p1 = polyfit(1911:2010,valsy,1);
        x1 = 1911:2010;
        y1 = polyval(p1,x1);
        Detrended_obs(i,:,j) = valsy - y1';
    end
end


%% Histogram for Standard Deviation
model_SD = squeeze(std(Detrended,[],2)); % CHOOSE: Detrended or not
% model_SD = squeeze(std(Pchange_all(:,1:100,:),[],2)); % CHOOSE: Detrended or not
hist_vals = nan(20,4);

for i = 1:20
    for j = 1:4
        hist_vals(i,j) = sum(model_SD(:,j) >= (0+(i-1)/100) & model_SD(:,j) < (0.01+(i-1)/100)) ;
    end
end

x = 0.005:0.01:0.195;
seas = {'(d) MAM','(a) JJA','(b) SON','(c) DJF'};

figure
set(gcf, 'color', 'w');
for ii = 1:4
    i = ii+1;
    if i == 5
        i=1;
    end
    subplot(2,2,ii)
    bar(x,hist_vals(:,i),'BarWidth',1)
    hold on
%     plot(nanstd(P_means(2:101,:,i),[],1),[1 1],'pk',MarkerFaceColor='k',MarkerSize=10) % CHOOSE: Detrended or not
    plot(nanstd(Detrended_obs(:,:,i),[],2),[1 1],'pk',MarkerFaceColor='k',MarkerSize=10) % CHOOSE: Detrended or not

    set(gca,'fontsize',16)

    xlabel('Precipitation standard deviation 1911-2010')
    ylabel('No. of models')
    title(seas(i))
end


