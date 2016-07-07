function datasets = cluster_volumes(s)

% datasets will store the organized dataset for each volume
datasets = {};
    
    for vol = 1:10
        
        trials = s.timeSeriesArrayHash.value{vol+1}.trial;
        % times = s.timeSeriesArrayHash.value{volume+1}.time;
        % rel_dF = s.timeSeriesArrayHash.value{volume+1}.valueMatrix;
        trial_ids = unique(trials);
        
        datasets{vol} = createDatasetForVolume(s,vol);
        
        
        % calculating the distance
        D = pdist(datasets{vol}','euclidean');
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
        
        saveas(gcf,sprintf('results_clustering/clustering_vol%d.png',vol))
        
    end
end