function [options] = mixNmatchMF_epinions_CLiMF(options)
	options = mixNmatchMF_options_CLiMF(options);

	% gradient ascent
	options.stepSize = 0.0001;
	options.nDims = 10;

	options.lambdaU = -0.001;
	options.lambdaV = options.lambdaU;
end
