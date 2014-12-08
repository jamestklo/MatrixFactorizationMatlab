function [options] = mixNmatchMF_options_L2(options)
	options.objectiveAll = @mixNmatchMF_lossAll_L2;
	options.objectiveAt = @mixNmatchMF_lossAt_L2;

	addpath '../mixNmatchMF_L2/';
	options.regularizeAt = @mixNmatchMF_regularizeAt_L2;

	addpath '../mixNmatchMF_data/';
	options = mixNmatchMF_options_descent(options);
end
