function [options] = mixNmatchMF_options_CLiMF(options)
	addpath '../mixNmatchMF_L2/';
    
	options.objectiveAll = @mixNmatchMF_objective_CLiMF;
	options.objectiveAt = @mixNmatchMF_objectiveAt_L2;

	options.regularizeAt = @mixNmatchMF_regularizeAt_L2;
end
