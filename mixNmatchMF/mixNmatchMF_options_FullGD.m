function [options] = mixNmatchMF_options_FullGD(options)
	options.batchAt = @mixNmatchMF_batchAt_random;
	options.batchSize = 0;
	options.update = @mixNmatchMF_update_batch;
end
