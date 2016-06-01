%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This script performs clustering of the trials by first reducing the 
%    dimension with classical multidimensional scaling, and then running
%    kmeans clustering. The clustered trials are visualized by plotting 
%    the first two (MDS) dimensions.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% read the data
load an197522_2013_03_08_session.mat

% select volume to process
volume = 3;

trials = s.timeSeriesArrayHash.value{volume+1}.trial;
times = s.timeSeriesArrayHash.value{volume+1}.time;
rel_dF = s.timeSeriesArrayHash.value{volume+1}.valueMatrix;
trial_ids = unique(trials);


% extract the data for each trial (data is cells x times)
res = {};

for i=1:length(unique(trials))
    
    % calculate relative times for individual trials (divide by 1000 since in miliseconds)
    rel_times = (times(trials == trial_ids(i))-s.trialStartTimes(trial_ids(i)))/1000;
    
    % interpolate at a fixed time grid
    res{i} = interp1(rel_times,rel_dF(:,trials == trial_ids(i))',0:0.01:12,'linear',0);
    
    imagesc(res{i}')
    %plot(rel_times,rel_dF(:,trials == trials(i))')
    %xlim([0 12])
    pause(0.01) 
end

% extracting the dimensions
[nofCells timePoints] = size(res{1});
nofTrials = length(res);

% reshaping the data
a = (reshape(cell2mat(res),nofCells,timePoints,nofTrials));
b = permute(a,[2,1,3]);
c = reshape(b,nofCells*timePoints,nofTrials);


% drop NAs
idx_NAs = sum(isnan(c),1)>0;
c = c(:,~idx_NAs);

% calculating the distance
D = pdist(c','euclidean');
[Y,e] = cmdscale(D);

% calculate the number of clusters
[m,trialTypes] = max(s.trialTypeMat(:,trial_ids));
nofClusters = length(unique(trialTypes));

% do kmeans clustering
clusters = kmeans(Y,nofClusters);

% create color labels for the k-means clusters
colors = colormap(lines(6));
color_labels = zeros(length(clusters),3);
for i=1:length(clusters)
    color_labels(i,:) = colors(clusters(i),:)';

end

% plot the k-means clusters
subplot(2,1,1)
scatter(Y(:,1),Y(:,2),30,color_labels,'filled')
title('K-means Clusters')

% create color labels for the trial types
colors = colormap(lines(6));
color_labels = zeros(length(clusters),3);

for i=1:length(clusters)
    color_labels(i,:) = colors(trialTypes(i),:)';
end

% plot the trial types
subplot(2,1,2)
scatter(Y(:,1),Y(:,2),30,color_labels,'filled')
title('Trial Types')

% add the type names
textLabels =  s.trialTypeStr(trialTypes);

for ii = 1:numel(Y(:,1)) 
    text(Y(ii,1)+2, Y(ii,2)+4,textLabels(ii),'FontSize',8) 
end





