function [options] = mixNmatchMF_gradient_descent(options)
	% gradient descent
	options.stepSize = -0.0001;
	options.nDims = 5;

	options.lambdaU = +0.001;
	options.lambdaV = options.lambdaU;
end
