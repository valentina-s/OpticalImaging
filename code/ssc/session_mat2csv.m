% specify session matlab file
data_path = '../../data/SvobodaLabSSCData/CRCNS/';
load(fullfile(data_path,'an197522_2013_03_08_session.mat'))

if ~exist(sprintf('%san197522_2013_03_08_session/',data_path))
    mkdir(sprintf('%san197522_2013_03_08_session/',data_path))
end

output_path = sprintf('%san197522_2013_03_08_session/',data_path);

% extracting the activity
times = s.timeSeriesArrayHash.value{1}.time;
activity = s.timeSeriesArrayHash.value{1}.valueMatrix;
csvwrite(sprintf('%sactivity.csv',output_path),[times;activity])

% extracting the fluorescent data
for i=2:10
    rel_dF = s.timeSeriesArrayHash.value{i}.valueMatrix;
    csvwrite(sprintf('%srelDf_%d.csv',output_path,i-1),[s.timeSeriesArrayHash.value{i}.time;rel_dF])
end

