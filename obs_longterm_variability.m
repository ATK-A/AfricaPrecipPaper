% obs_longterm_variability.m
%% CRU
% Max length: 1971-2020
lon_CRU = double(ncread('../Precipitation/CRU/cru_ts4.07.1971.1980.pre.dat.nc','lon'));
lat_CRU = double(ncread('../Precipitation/CRU/cru_ts4.07.1971.1980.pre.dat.nc','lat'));

% Load only required lat-long extent
id1 = lat_CRU == 6.75;
id2 = lat_CRU == -36.75;
vals = 1:360;
startid = vals(id1);
endid = vals(id2);
lat_CRU_sub = lat_CRU(min([startid,endid]):max([startid,endid]));

lat_start = min([startid,endid]);
lat_count = abs(endid-startid)+1;

id1 = lon_CRU == 11.25;
id2 = lon_CRU == 51.75;
vals = 1:720;
startid = vals(id1);
endid = vals(id2);
lon_CRU_sub = lon_CRU(min([startid,endid]):max([startid,endid]));

lon_start = min([startid,endid]);
lon_count = abs(endid-startid)+1;

% Time subset (from inspecting data in Panoply)
time_start = 37;
time_count = 12*7;

P_CRU = ncread('../Precipitation/CRU/cru_ts4.07.1901.1910.pre.dat.nc','pre',[lon_start, lat_start, 1],[lon_count, lat_count, Inf]); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_CRU = cat(3,P_CRU,ncread('../Precipitation/CRU/cru_ts4.07.1911.1920.pre.dat.nc','pre',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_CRU = cat(3,P_CRU,ncread('../Precipitation/CRU/cru_ts4.07.1921.1930.pre.dat.nc','pre',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_CRU = cat(3,P_CRU,ncread('../Precipitation/CRU/cru_ts4.07.1931.1940.pre.dat.nc','pre',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_CRU = cat(3,P_CRU,ncread('../Precipitation/CRU/cru_ts4.07.1941.1950.pre.dat.nc','pre',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_CRU = cat(3,P_CRU,ncread('../Precipitation/CRU/cru_ts4.07.1951.1960.pre.dat.nc','pre',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_CRU = cat(3,P_CRU,ncread('../Precipitation/CRU/cru_ts4.07.1961.1970.pre.dat.nc','pre',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_CRU = cat(3,P_CRU,ncread('../Precipitation/CRU/cru_ts4.07.1971.1980.pre.dat.nc','pre',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_CRU = cat(3,P_CRU,ncread('../Precipitation/CRU/cru_ts4.07.1981.1990.pre.dat.nc','pre',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_CRU = cat(3,P_CRU,ncread('../Precipitation/CRU/cru_ts4.07.1991.2000.pre.dat.nc','pre',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_CRU = cat(3,P_CRU,ncread('../Precipitation/CRU/cru_ts4.07.2001.2010.pre.dat.nc','pre',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_CRU = cat(3,P_CRU,ncread('../Precipitation/CRU/cru_ts4.07.2011.2020.pre.dat.nc','pre',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total

% Unit is a monthly total: convert to daily average -> Turns out this was already the case. Keeping this code only in case it is useful elsewhere
% Create an array of number of days per month
day_count = nan(82,88,12*120);
y=1901;
m=1;
for i = 1:12*120
    startt = datetime(y,m,1);
    if m < 12
        endt = datetime(y,m+1,1);
        day_count(:,:,i) = days(endt-startt);
        m = m+1;
    else
        endt = datetime(y+1,1,1);
        day_count(:,:,i) = days(endt-startt);
        m=1;
        y = y+1;
    end
end

P_CRU = P_CRU./day_count;
P_CRU_seas_running = nan(82,88,101,4);

% Time averaging
P_CRU_seas = nan(82,88,120,4);


for seas = 1:4
    for i = 1:120
        
        if seas ~= 4
            ids = ((seas-1)*3+3:(seas-1)*3+5)+(i-1)*12;
        else
            ids = [12,1,2]+(i-1)*12;
        end

        P_CRU_seas(:,:,i,seas) = mean(P_CRU(:,:,ids),3);
    end

    % Calc running mean
    for i = 1:101
        P_CRU_seas_running(:,:,i,seas) = mean(P_CRU_seas(:,:,i:i+19,seas),3);
    end
end

%% GPCC
% Max length: 1971-2020
lon_GPCC = double(ncread('../Precipitation/GPCC/full_data_monthly_v2022_1971_1980_025.nc','lon'));
lat_GPCC = double(ncread('../Precipitation/GPCC/full_data_monthly_v2022_1971_1980_025.nc','lat'));

% Load only required lat-long extent
id1 = lat_GPCC == 6.875;
id2 = lat_GPCC == -36.875;
vals = 1:720;
startid = vals(id1);
endid = vals(id2);
lat_GPCC_sub = lat_GPCC(min([startid,endid]):max([startid,endid]));

lat_start = min([startid,endid]);
lat_count = abs(endid-startid)+1;

id1 = lon_GPCC == 11.125;
id2 = lon_GPCC == 51.875;
vals = 1:1440;
startid = vals(id1);
endid = vals(id2);
lon_GPCC_sub = lon_GPCC(min([startid,endid]):max([startid,endid]));

lon_start = min([startid,endid]);
lon_count = abs(endid-startid)+1;

% Time subset (from inspecting data in Panoply)
time_start = 37;
time_count = 12*7;

P_GPCC = ncread('../Precipitation/GPCC/full_data_monthly_v2022_1901_1910_025.nc','precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf]); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_GPCC = cat(3,P_GPCC,ncread('../Precipitation/GPCC/full_data_monthly_v2022_1911_1920_025.nc','precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_GPCC = cat(3,P_GPCC,ncread('../Precipitation/GPCC/full_data_monthly_v2022_1921_1930_025.nc','precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_GPCC = cat(3,P_GPCC,ncread('../Precipitation/GPCC/full_data_monthly_v2022_1931_1940_025.nc','precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_GPCC = cat(3,P_GPCC,ncread('../Precipitation/GPCC/full_data_monthly_v2022_1941_1950_025.nc','precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_GPCC = cat(3,P_GPCC,ncread('../Precipitation/GPCC/full_data_monthly_v2022_1951_1960_025.nc','precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_GPCC = cat(3,P_GPCC,ncread('../Precipitation/GPCC/full_data_monthly_v2022_1961_1970_025.nc','precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_GPCC = cat(3,P_GPCC,ncread('../Precipitation/GPCC/full_data_monthly_v2022_1971_1980_025.nc','precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_GPCC = cat(3,P_GPCC,ncread('../Precipitation/GPCC/full_data_monthly_v2022_1981_1990_025.nc','precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_GPCC = cat(3,P_GPCC,ncread('../Precipitation/GPCC/full_data_monthly_v2022_1991_2000_025.nc','precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_GPCC = cat(3,P_GPCC,ncread('../Precipitation/GPCC/full_data_monthly_v2022_2001_2010_025.nc','precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
P_GPCC = cat(3,P_GPCC,ncread('../Precipitation/GPCC/full_data_monthly_v2022_2011_2020_025.nc','precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total

% Unit is a monthly total: convert to daily average -> Turns out this was already the case. Keeping this code only in case it is useful elsewhere
% Create an array of number of days per month
day_count = nan(164,176,12*120);
y=1901;
m=1;
for i = 1:12*120
    startt = datetime(y,m,1);
    if m < 12
        endt = datetime(y,m+1,1);
        day_count(:,:,i) = days(endt-startt);
        m = m+1;
    else
        endt = datetime(y+1,1,1);
        day_count(:,:,i) = days(endt-startt);
        m=1;
        y = y+1;
    end
end

P_GPCC = P_GPCC./day_count;


% Time averaging
P_GPCC_seas = nan(164,176,120,4);
P_GPCC_seas_running = nan(164,176,101,4);

for seas = 1:4
    for i = 1:120

        if seas ~= 4
            ids = ((seas-1)*3+3:(seas-1)*3+5)+(i-1)*12;
        else
            ids = [12,1,2]+(i-1)*12;
        end

        P_GPCC_seas(:,:,i,seas) = mean(P_GPCC(:,:,ids),3);
    end

    % Calc running mean
    for i = 1:101
        P_GPCC_seas_running(:,:,i,seas) = mean(P_GPCC_seas(:,:,i:i+19,seas),3);
    end
end


%% CHIRPS
% Max length = 1981-2017
lon_CHIRPS = double(ncread('../Precipitation/CHIRPS/chirps-v2.0.1981.days_p25.nc','longitude'));
lat_CHIRPS = double(ncread('../Precipitation/CHIRPS/chirps-v2.0.1981.days_p25.nc','latitude'));

% Load only required lat-long extent
id1 = lat_CHIRPS == 6.875;
id2 = lat_CHIRPS == -36.875;
vals = 1:400;
startid = vals(id1);
endid = vals(id2);
lat_CHIRPS_sub = lat_CHIRPS(min([startid,endid]):max([startid,endid]));

lat_start = min([startid,endid]);
lat_count = abs(endid-startid)+1;

id1 = lon_CHIRPS == 11.125;
id2 = lon_CHIRPS == 51.875;
vals = 1:1440;
startid = vals(id1);
endid = vals(id2);
lon_CHIRPS_sub = lon_CHIRPS(min([startid,endid]):max([startid,endid]));

lon_start = min([startid,endid]);
lon_count = abs(endid-startid)+1;

% Get list of file names
files = dir('../Precipitation/CHIRPS/*_p25.nc'); 

% Load data
year1 = 1981;
count = 1;
P_CHIRPS = nan(lon_count,lat_count,37*12);

% for i = 1:length(files)
for i = 1:37 % Don't need to load all files
    file = [files(i).folder,'/',files(i).name];
    P = ncread(file,'precip',[lon_start, lat_start, 1],[lon_count, lat_count, Inf]);

    % Calculate monthly average
    startt = datetime(year1,1,1);
    endt = datetime(year1,12,31);
    daysid = startt:endt;

    for m = 1:12
        ids = month(daysid) == m;
        P_CHIRPS(:,:,count) = nanmean(P(:,:,ids),3);
        count = count+1;
    end
    year1 = year1+1;
end

% Time averaging
P_CHIRPS_seas = nan(164,176,37,4);
P_CHIRPS_seas_running = nan(164,176,18,4);

for seas = 1:4
    for i = 1:37
        
        if seas ~= 4
            ids = ((seas-1)*3+3:(seas-1)*3+5)+(i-1)*12;
        else
            ids = [12,1,2]+(i-1)*12;
        end

        P_CHIRPS_seas(:,:,i,seas) = mean(P_CHIRPS(:,:,ids),3);
    end


    % Calc running mean
    for i = 1:18
        P_CHIRPS_seas_running(:,:,i,seas) = mean(P_CHIRPS_seas(:,:,i:i+19,seas),3);
    end
end


%% GPCP
% Max length: 1980-2022
lon_GPCP = double(ncread('../Precipitation/GPCP/gpcp_v02r03_monthly_d198401_c20170616.nc','longitude'));
lat_GPCP = double(ncread('../Precipitation/GPCP/gpcp_v02r03_monthly_d198401_c20170616.nc','latitude'));

% Load only required lat-long extent
id1 = lat_GPCP == 6.25;
id2 = lat_GPCP == -36.25;
vals = 1:72;
startid = vals(id1);
endid = vals(id2);
lat_GPCP_sub = lat_GPCP(min([startid,endid]):max([startid,endid]));

lat_start = min([startid,endid]);
lat_count = abs(endid-startid)+1;

id1 = lon_GPCP == 11.25;
id2 = lon_GPCP == 51.25;
vals = 1:144;
startid = vals(id1);
endid = vals(id2);
lon_GPCP_sub = lon_GPCP(min([startid,endid]):max([startid,endid]));

lon_start = min([startid,endid]);
lon_count = abs(endid-startid)+1;


P_GPCP = nan([17,18,43*12]);
count = 1;
for i = 1:43
    for j = 1:12
        yearid = num2str(i+1979);
        monthid = sprintf('%02d',j);
        file = dir(['../Precipitation/GPCP/gpcp_v02r03_monthly_d',yearid,monthid,'_c20*.nc']);
        P_GPCP(:,:,count) = ncread(['../Precipitation/GPCP/',file.name],'precip',[lon_start, lat_start, 1],[lon_count, lat_count, 1]); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
        count = count+1;
    end
end

% Time averaging
P_GPCP_seas = nan(17,18,43,4);
P_GPCP_seas_running = nan(17,18,24,4);

for seas = 1:4
    for i = 1:43
        
        if seas ~= 4
            ids = ((seas-1)*3+3:(seas-1)*3+5)+(i-1)*12;
        else
            ids = [12,1,2]+(i-1)*12;
        end
        P_GPCP_seas(:,:,i,seas) = mean(P_GPCP(:,:,ids),3);
    end


    % Calc running mean
    for i = 1:24
        P_GPCP_seas_running(:,:,i,seas) = mean(P_GPCP_seas(:,:,i:i+19,seas),3);
    end
end

%% MSWEP
% Max length: 1980-2019
lon_MSWEP = double(ncread('../Precipitation/MSWEP/197902.nc','lon'));
lat_MSWEP = double(ncread('../Precipitation/MSWEP/197902.nc','lat'));

% Load only required lat-long extent
id1 = ismembertol(lat_MSWEP,6.95,0.0005);
id2 = ismembertol(lat_MSWEP,-36.95,0.0005);
vals = 1:1800;
startid = vals(id1);
endid = vals(id2);
lat_MSWEP_sub = lat_MSWEP(min([startid,endid]):max([startid,endid]));

lat_start = min([startid,endid]);
lat_count = abs(endid-startid)+1;

id1 = ismembertol(lon_MSWEP,11.05,0.0005);
id2 = ismembertol(lon_MSWEP,51.95,0.0005);
vals = 1:3600;
startid = vals(id1);
endid = vals(id2);
lon_MSWEP_sub = lon_MSWEP(min([startid,endid]):max([startid,endid]));

lon_start = min([startid,endid]);
lon_count = abs(endid-startid)+1;

P_MSWEP = nan(410,440,40*12);

count = 1;
for i = 1:40
    for j = 1:12
        yearid = num2str(i+1979);
        monthid = sprintf('%02d',j);
        P_MSWEP(:,:,count) = ncread(['../Precipitation/MSWEP/',yearid,monthid,'.nc'],'precipitation',[lon_start, lat_start, 1],[lon_count, lat_count, 1]); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total
        count = count+1;
    end
end

% Unit is a monthly total: convert to daily average -> Turns out this was already the case. Keeping this code only in case it is useful elsewhere
% Create an array of number of days per month
day_count = nan(410,440,12*40);
y=1980;
m=1;
for i = 1:12*40
    startt = datetime(y,m,1);
    if m < 12
        endt = datetime(y,m+1,1);
        day_count(:,:,i) = days(endt-startt);
        m = m+1;
    else
        endt = datetime(y+1,1,1);
        day_count(:,:,i) = days(endt-startt);
        m=1;
        y = y+1;
    end
end

P_MSWEP = P_MSWEP./day_count;

% Time averaging
P_MSWEP_seas = nan(410,440,40,4);
P_MSWEP_seas_running = nan(410,440,21,4);

for seas = 1:4
    for i = 1:40
        
        if seas ~= 4
            ids = ((seas-1)*3+3:(seas-1)*3+5)+(i-1)*12;
        else
            ids = [12,1,2]+(i-1)*12;
        end

        P_MSWEP_seas(:,:,i,seas) = mean(P_MSWEP(:,:,ids),3);
    end


    % Calc running mean
    for i = 1:21
        P_MSWEP_seas_running(:,:,i,seas) = mean(P_MSWEP_seas(:,:,i:i+19,seas),3);
    end
end


%% PERSIANN-CDR
% Max length: 1983-2020
lon_PERSIANN = double(ncread('../Precipitation/PERSIANN-CDR/CDR_2024-01-23064004am.nc','lon'));
lat_PERSIANN = double(ncread('../Precipitation/PERSIANN-CDR/CDR_2024-01-23064004am.nc','lat'));

% Load only required lat-long extent
id1 = lat_PERSIANN == 6.75;
id2 = lat_PERSIANN == -36.75;
vals = 1:480;
startid = vals(id1);
endid = vals(id2);
lat_PERSIANN_sub = lat_PERSIANN(min([startid,endid]):max([startid,endid]));

lat_start = min([startid,endid]);
lat_count = abs(endid-startid)+1;

id1 = lon_PERSIANN == 11.25;
id2 = lon_PERSIANN == 51.75;
vals = 1:1440;
startid = vals(id1);
endid = vals(id2);
lon_PERSIANN_sub = lon_PERSIANN(min([startid,endid]):max([startid,endid]));

lon_start = min([startid,endid]);
lon_count = abs(endid-startid)+1;

% Time subset (from inspecting data in Panoply)
time_start = 1;
time_count = 12*37;

P_PERSIANN = double(ncread('../Precipitation/PERSIANN-CDR/CDR_2024-01-23064004am.nc','precip',[lon_start, lat_start, time_start],[lon_count, lat_count, time_count])); % This is an averge of 3-hourly precip. -> multiply by 8 to get daily total

% Unit is a monthly total: convert to daily average -> Turns out this was already the case. Keeping this code only in case it is useful elsewhere
% Create an array of number of days per month
day_count = nan(163,175,12*37);
y=1983;
m=1;
for i = 1:12*37
    startt = datetime(y,m,1);
    if m < 12
        endt = datetime(y,m+1,1);
        day_count(:,:,i) = days(endt-startt);
        m = m+1;
    else
        endt = datetime(y+1,1,1);
        day_count(:,:,i) = days(endt-startt);
        m=1;
        y = y+1;
    end
end

P_PERSIANN = P_PERSIANN./day_count;

% Time averaging
P_PERSIANN_seas = nan(163,175,37,4);
P_PERSIANN_seas_running = nan(163,175,18,4);

for seas = 1:4
    for i = 1:37
        
        if seas ~= 4
            ids = ((seas-1)*3+3:(seas-1)*3+5)+(i-1)*12;
        else
            ids = [12,1,2]+(i-1)*12;
        end

        P_PERSIANN_seas(:,:,i,seas) = mean(P_PERSIANN(:,:,ids),3);
    end


    % Calc running mean
    for i = 1:18
        P_PERSIANN_seas_running(:,:,i,seas) = mean(P_PERSIANN_seas(:,:,i:i+19,seas),3);
    end
end


%% REGEN-ALL
% Max length: 1979-2016
lon_REGEN = double(ncread('../Precipitation/REGEN-ALL/REGEN_LongTermStns_V1-2019_1979.nc','lon'));
lat_REGEN = double(ncread('../Precipitation/REGEN-ALL/REGEN_LongTermStns_V1-2019_1979.nc','lat'));

% Load only required lat-long extent
id1 = lat_REGEN == 6.5;
id2 = lat_REGEN == -36.5;
vals = 1:180;
startid = vals(id1);
endid = vals(id2);
lat_REGEN_sub = lat_REGEN(min([startid,endid]):max([startid,endid]));

lat_start = min([startid,endid]);
lat_count = abs(endid-startid)+1;

id1 = lon_REGEN == 11.5;
id2 = lon_REGEN == 51.5;
vals = 1:360;
startid = vals(id1);
endid = vals(id2);
lon_REGEN_sub = lon_REGEN(min([startid,endid]):max([startid,endid]));

lon_start = min([startid,endid]);
lon_count = abs(endid-startid)+1;

% Load data
count = 1;
P_REGEN = nan(lon_count,lat_count,372);

for i = 1979:2016 % Don't need to load all files
    file = ['../Precipitation/REGEN-ALL/REGEN_LongTermStns_V1-2019_',num2str(i),'.nc'];
    P = double(ncread(file,'p',[lon_start, lat_start, 1],[lon_count, lat_count, Inf]));

%     % Remove any nan values
%     P(P<-1e2) = nan;

    % Calculate monthly average
    startt = datetime(i,1,1);
    endt = datetime(i,12,31);
    daysid = startt:endt;

    for m = 1:12
        ids = month(daysid) == m;
        P_REGEN(:,:,count) = nanmean(P(:,:,ids),3);
        count = count+1;
    end
end

% Time averaging
P_REGEN_seas = nan(41,44,38,4);
P_REGEN_seas_running = nan(41,44,19,4);

for seas = 1:4
    for i = 1:38
        
        if seas ~= 4
            ids = ((seas-1)*3+3:(seas-1)*3+5)+(i-1)*12;
        else
            ids = [12,1,2]+(i-1)*12;
        end

        P_REGEN_seas(:,:,i,seas) = mean(P_REGEN(:,:,ids),3);
    end

    % Calc running mean
    for i = 1:19
        P_REGEN_seas_running(:,:,i,seas) = mean(P_REGEN_seas(:,:,i:i+19,seas),3);
    end
end


%% TAMSAT
% Max length: 1983-2022
lon_TAMSAT = double(ncread('../Precipitation/TAMSAT/rfe1983-present_daily_1.00.v3.1.nc','lon'));
lat_TAMSAT = double(ncread('../Precipitation/TAMSAT/rfe1983-present_daily_1.00.v3.1.nc','lat'));

% Load only required lat-long extent
id1 = lat_TAMSAT == 6.5;
id2 = lat_TAMSAT == -35.5;
vals = 1:180;
startid = vals(id1);
endid = vals(id2);
lat_TAMSAT_sub = lat_TAMSAT(min([startid,endid]):max([startid,endid]));

lat_start = min([startid,endid]);
lat_count = abs(endid-startid)+1;

id1 = lon_TAMSAT == 11.5;
id2 = lon_TAMSAT == 51.5;
vals = 1:360;
startid = vals(id1);
endid = vals(id2);
lon_TAMSAT_sub = lon_TAMSAT(min([startid,endid]):max([startid,endid]));

lon_start = min([startid,endid]);
lon_count = abs(endid-startid)+1;

% Load data
count = 1;
P_TAMSAT = nan(lon_count,lat_count,372);


countid = 1;
for i = 1983:2022 % Don't need to load all files
    % Calculate monthly average
    startt = datetime(i,1,1);
    endt = datetime(i,12,31);
    daysid = startt:endt;
    dayslen = days(endt-startt)+1;

    % Load data for this year
    P = double(ncread('../Precipitation/TAMSAT/rfe1983-present_daily_1.00.v3.1.nc','rfe_filled',[lon_start, lat_start, countid],[lon_count, lat_count, dayslen]));
    countid=countid+dayslen; % Update counter for next year

    for m = 1:12
        ids = month(daysid) == m;
        P_TAMSAT(:,:,count) = nanmean(P(:,:,ids),3);
        count = count+1;
    end
end

% Time averaging
P_TAMSAT_seas = nan(41,43,40,4);
P_TAMSAT_seas_running = nan(41,43,21,4);

for seas = 1:4
    for i = 1:40
        
        if seas ~= 4
            ids = ((seas-1)*3+3:(seas-1)*3+5)+(i-1)*12;
        else
            ids = [12,1,2]+(i-1)*12;
        end

        P_TAMSAT_seas(:,:,i,seas) = mean(P_TAMSAT(:,:,ids),3);
    end

    % Calc running mean
    for i = 1:21
        P_TAMSAT_seas_running(:,:,i,seas) = mean(P_TAMSAT_seas(:,:,i:i+19,seas),3);
    end
end


%% Re-gridding
[lats_CRU_sub,lons_CRU_sub] = meshgrid(lat_CRU_sub,lon_CRU_sub);
[lats_GPCC_sub,lons_GPCC_sub] = meshgrid(lat_GPCC_sub,lon_GPCC_sub);
[lats1,lons1] = meshgrid(lat_REGEN_sub,lon_REGEN_sub);
[lats_CHIRPS_sub,lons_CHIRPS_sub] = meshgrid(lat_CHIRPS_sub,lon_CHIRPS_sub);
% [lats_CPC_sub,lons_CPC_sub] = meshgrid(lat_CPC_sub,lon_CPC_sub);
[lats_GPCP_sub,lons_GPCP_sub] = meshgrid(lat_GPCP_sub,lon_GPCP_sub);
[lats_MSWEP_sub,lons_MSWEP_sub] = meshgrid(lat_MSWEP_sub,lon_MSWEP_sub);
[lats_PERSIANN_sub,lons_PERSIANN_sub] = meshgrid(double(lat_PERSIANN_sub),double(lon_PERSIANN_sub));
[lats_TAMSAT_sub,lons_TAMSAT_sub] = meshgrid(lat_TAMSAT_sub,lon_TAMSAT_sub);

P_regridded_all = nan(41,44,103,4,8);

seasnames = {'MAM','JJA','SON','DJF'};

for seas = 1:4
    disp(['Starting '+string(seasnames(seas))])
    disp('   ')
    disp(['Processing CRU and GPCC'])
    for i = 1:101
        P_regridded_all(:,:,i,seas,3) = griddata(lons_CRU_sub,lats_CRU_sub,P_CRU_seas_running(:,:,i,seas),lons1,lats1,'linear');
        P_regridded_all(:,:,i,seas,4) = griddata(lons_GPCC_sub,lats_GPCC_sub,P_GPCC_seas_running(:,:,i,seas),lons1,lats1,'linear');
    end

    disp(['Processing CHIRPS'])
    for i = 1:18
        P_regridded_all(:,:,i+80,seas,1) = griddata(lons_CHIRPS_sub,lats_CHIRPS_sub,P_CHIRPS_seas_running(:,:,i,seas),lons1,lats1,'linear');
    end

    disp(['Processing GPCP'])
    for i = 1:24
        P_regridded_all(:,:,i+79,seas,2) = griddata(lons_GPCP_sub,lats_GPCP_sub,P_GPCP_seas_running(:,:,i,seas),lons1,lats1,'linear');
    end

    disp(['Processing MSWEP'])
    for i = 1:21
        P_regridded_all(:,:,i+78,seas,5) = griddata(lons_MSWEP_sub,lats_MSWEP_sub,P_MSWEP_seas_running(:,:,i,seas),lons1,lats1,'linear');
    end

    disp(['Processing PERSIANN'])
    for i = 1:18
        P_regridded_all(:,:,i+82,seas,6) = griddata(lons_PERSIANN_sub,lats_PERSIANN_sub,P_PERSIANN_seas_running(:,:,i,seas),lons1,lats1,'linear');
    end

    disp(['Processing REGEN'])
    for i = 1:19
        P_regridded_all(:,:,i+78,seas,7) = P_REGEN_seas_running(:,:,i,seas);
    end

    disp(['Processing TAMSAT'])
    for i = 1:21
        P_regridded_all(:,:,i+82,seas,8) = griddata(lons_TAMSAT_sub,lats_TAMSAT_sub,P_TAMSAT_seas_running(:,:,i,seas),lons1,lats1,'linear');
    end
end


%% Area average

% Define region limits (according to Python, need to +1 here and reverse order?):
% West = [1:18,0:12]
% East = [2:14,14:23]
% Large: [4:23,8:29]
% Uncertain: [14:23,8:29]
lons_id = 10:30;%8:29;
lats_id = 6:24;%4:23;

mask1 = squeeze(nanmean(P_regridded_all(lons_id,lats_id,:,1,:),3));
mask2 = sum(isnan(mask1),3);
mask = (mask2==0)*1;
mask(mask2>0) = nan;
mask_rep = repmat(mask,1,1,103,4,8);


% [21, -22], width=9, height=9
if exist('areas.mat','file')
    load('areas.mat')
else
    cd ../Fire/
    areas = calc_latlon_area(lats1,lons1,'areaquad');
end

% areas_sub = areas(11:19,16:24)./sum(sum(areas(11:19,16:24)));
% P_regridded_all_sub = P_regridded_all(11:19,16:24,:,:);
areas_sub = areas(lons_id,lats_id)./nansum(nansum(areas(lons_id,lats_id).*mask));
P_regridded_all_sub = P_regridded_all(lons_id,lats_id,:,:,:);
areas_sub_rep = repmat(areas_sub,1,1,103,4,8);

P_means = squeeze(nansum(nansum(P_regridded_all_sub.*areas_sub_rep.*mask_rep,2),1));

for i = 1:103
    for j = 1:8
        if isnan(P_regridded_all_sub(19,19,i,1,j))
            P_means(i,:,j) = nan;
        end
    end
end
