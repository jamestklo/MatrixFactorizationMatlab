function [options] = mixNmatchMF_options_BPR(options)
	options.objectiveAll = @mixNmatchMF_objectiveAll_BPR;
	options.objectiveAt = @mixNmatchMF_objectiveAt_BPR;

	addpath '../mixNmatchMF_L2/';
	options.regularizeAt = @mixNmatchMF_regularizeAt_L2;

	addpath '../mixNmatchMF/';
	options = mixNmatchMF_options_descent(options);
end
