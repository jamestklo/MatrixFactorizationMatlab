function [options] = mixNmatchMF_options_StochasticGD(options)
	options.batchAt = @mixNmatchMF_batchAt_random;
	options.batchSize = 1;
	options.update = @mixNmatchMF_update_batch;
end
