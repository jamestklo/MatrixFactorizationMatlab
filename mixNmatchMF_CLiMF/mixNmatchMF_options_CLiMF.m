function [options] = mixNmatchMF_options_CLiMF(options)
	options.objectiveAll = @mixNmatchMF_objective_CLiMF;
	options.objectiveAt = @mixNmatchMF_objectiveAt_CLiMF;

	addpath '../mixNmatchMF_L2/';
	options.regularizeAt = @mixNmatchMF_regularizeAt_L2;

	addpath '../mixNmatchMF_data/';
	options = mixNmatchMF_options_ascent(options);
end
