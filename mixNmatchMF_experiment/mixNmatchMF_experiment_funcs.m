function [] = mixNmatchMF_experiment_funcs()
	clear all;
	close all;
	
	if false
		options = struct;
		options.maxIter = 5000;
		addpath '../mixNmatchMF_L2';
		mixNmatchMF_experiment_datasets(@mixNmatchMF_options_L2, './L2.mat', options)
		clear all;
		close all;
	end

	if true
		options = struct;
		options.maxIter = 2;		
		addpath '../mixNmatchMF_CLiMF/';
		mixNmatchMF_experiment_datasets(@mixNmatchMF_options_CLiMF, './CLiMF.mat', options);
		clear all;
		close all;
	end

	if false
		options = struct;
		options.maxIter = 5000;		
		addpath '../mixNmatchMF_BPR';
		mixNmatchMF_experiment_datasets(@mixNmatchMF_options_MMMF, './BPR.mat', options);
		clear all;
		close all;
	end
end
