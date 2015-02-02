function [isRegularizing, lambdaU, lambdaV] = mixNmatchMF_isRegularizing(options)
	if isfield(options, 'lambdaU')
		lambdaU = options.lambdaU;
	else
		lambdaU = 0;
		%options.lambdaU = 0;
	end
	if isfield(options, 'lambdaV')
		lambdaV = options.lambdaV;	
	else
		lambdaV = 0;
		%options.lambdaV = 0;
	end
	isRegularizing = isfield(options, 'regularizeAt') && (lambdaU ~= 0 || lambdaV ~= 0);
end