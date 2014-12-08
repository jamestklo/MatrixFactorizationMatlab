function [] = mixNmatchMF_experiment_CLiMF()
	options = struct;
	options.maxIter = 1;

	data = cell(2,1);

	addpath '../mixNmatchMF_data/';
	d = 1;
	data{d} = cell(4,1);
	data{d}{1} = 'epinionsT'; 
	data{d}{2} = options;	
	data{d}{3} = @mixNmatchMF_epinions_CLiMF; 
	data{d}{4} = @mixNmatchMF_data_epinionsTrain; 
	d = d + 1;

	%data{d} = cell(4,1);
	%data{d}{1} = 'epinionsS'; 
	%data{d}{2} = options;	
	%data{d}{3} = @mixNmatchMF_epinions_CLiMF; 
	%data{d}{4} = @mixNmatchMF_data_epinionsTest;	
	%d = d + 1;

	% start experiment
	addpath '../mixNmatchMF_experiment/';
	[results, labels] = mixNmatchMF_experiment_start(data, 2);

	% save results
	[table] = mixNmatchMF_experiment_save('./CLiMF', results, labels);
end
