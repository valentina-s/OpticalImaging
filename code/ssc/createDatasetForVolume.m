function dataset = createDatasetForVolume(s, volume, filename)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 
    % 
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
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
    
    dataset = reshape(b,nofCells*timePoints,nofTrials);

    % drop NAs
    idx_NAs = sum(isnan(dataset),1)>0;
    dataset = dataset(:,~idx_NAs);
    disp(size(dataset))
    
    if nargin>2
        csvwrite(filename,dataset)
    end
    
end