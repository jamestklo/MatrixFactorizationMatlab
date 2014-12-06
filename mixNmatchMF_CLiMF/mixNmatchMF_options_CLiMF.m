function [options] = mixNmatchMF_options_CLiMF(options)
	options.objectiveAll = @mixNmatchMF_objective_CLiMF;
	options.objectiveAt = @mixNmatchMF_objectiveAt_CLiMF;

	addpath '../mixNmatchMF_L2/';
	options.regularizeAt = @mixNmatchMF_regularizeAt_L2;
end

function [options] = mixNmatchMF_epinions_CLiMF(options)
	options = mixNmatchMF_options_CLiMF(options);

	% gradient ascent
	options.stepSize = 0.0001;
	options.nDims = 10;

	options.lambdaU = -0.001;
	options.lambdaV = options.lambdaU;
end
