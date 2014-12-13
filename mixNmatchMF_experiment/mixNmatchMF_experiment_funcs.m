function [] = mixNmatchMF_experiment_funcs()
	clear all;
	close all;
	
	if true
		options = struct;
		options.maxIter = 20000;
		addpath '../mixNmatchMF_L2';
		mixNmatchMF_experiment_datasets(@mixNmatchMF_options_L2, './L2_20000.mat', options)
		clear all;
		close all;
	end

	if false
		options = struct;
		options.maxIter = 20000;
		addpath '../mixNmatchMF_CLiMF/';
		mixNmatchMF_experiment_datasets(@mixNmatchMF_options_CLiMF, './CLiMF_20000.mat', options);
		clear all;
		close all;
	end

	if false
		options = struct;
		options.maxIter = 20000;		
		addpath '../mixNmatchMF_BPR/';
		mixNmatchMF_experiment_datasets(@mixNmatchMF_options_BPR, './BPR_20000.mat', options);
		clear all;
		close all;
	end
end
