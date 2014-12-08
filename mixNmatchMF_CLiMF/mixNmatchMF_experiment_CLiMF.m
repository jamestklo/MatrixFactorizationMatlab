function [] = mixNmatchMF_experiment_CLiMF()
	options = struct;
	options.maxIter = 1;

	data = cell(2,1);

	addpath '../mixNmatchMF_data_epinions/';
	data{1} = cell(4,1);
	data{1}{1} = 'epinionsT'; 
	data{1}{2} = options;	
	data{1}{3} = @mixNmatchMF_epinions_CLiMF; 
	data{1}{4} = @mixNmatchMF_data_epinionsTrain; 
	
	%data{2} = cell(4,1);
	%data{2}{1} = 'epinionsS'; 
	%data{2}{2} = options;	
	%data{2}{3} = @mixNmatchMF_epinions_CLiMF; 
	%data{2}{4} = @mixNmatchMF_data_epinionsTest;	

	% start experiment
	addpath '../mixNmatchMF_experiment/';
	[results, labels] = mixNmatchMF_experiment_start(data, 2);

	% save results
	[table] = mixNmatchMF_table_save('./CLiMF', results, labels);
end
