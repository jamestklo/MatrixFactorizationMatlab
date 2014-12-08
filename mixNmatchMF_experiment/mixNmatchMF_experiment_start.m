function [results, labels] = mixNmatchMF_experiment_start(data)
  results = cell(length(data), 1);
  labels  = cell(length(data), 1);

  % detect availability of parallel computing
  if exist('matlabpool') > 0
		matlabpool;
	elseif exist('parpool') > 0
		poolobj = parpool;
  end
  
  % parallel execution
  parfor d=1:length(results)
    if length(data{d}) > 0
     	labels{d}  = data{d}{1};
     	results{d} = mixNmatchMF_experiment_gradients(data{d}{2}, data{d}{3}, data{d}{4});
    end  	
  end

  if exist('matlabpool') > 0
  	matlabpool close;
  elseif exist('parpool') > 0
  	delete(poolobj);
  end
end


function [measurements] = mixNmatchMF_experiment_gradients(options, optionsF, readData)
  addpath '../mixNmatchMF/';

  gradients = cell(3, 1);
  gradients{1} = @mixNmatchMF_options_FullGD;
  gradients{2} = @mixNmatchMF_options_StochasticGD; 
  gradients{3} = @mixNmatchMF_options_SAG;

  measurements = cell(length(gradients), 1);
  parfor g=1:length(gradients)
    if isa(gradients{g}, 'function_handle')
      [f_all, t_opt, times_avg, times_999, memry_avg, memry_999] = mixNmatchMF_experiment_run(options, readData, optionsF, gradients{g});
      measurements{g} = [f_all, t_opt, times_avg, times_999, memry_avg, memry_999];
    end
  end
end


function [options] = mixNmatchMF_options_FullGD(options)
	options.batchAt = @mixNmatchMF_batchAt_random;
	options.batchSize = 0;
	options.update = @mixNmatchMF_update_batch;
	options.maxIter = max(options.maxIter / 10, 1);
end


function [options] = mixNmatchMF_options_StochasticGD(options)
	options.batchAt = @mixNmatchMF_batchAt_random;
	options.batchSize = 1;
	options.update = @mixNmatchMF_update_batch;
end


function [options] = mixNmatchMF_options_SAG(options)
	options.batchAt = @mixNmatchMF_batchAt_random;
	options.batchSize = -1;
	options.update = @mixNmatchMF_update_memory;
end


function [f_all, t_opt, times_avg, times_999, memry_avg, memry_999] = mixNmatchMF_experiment_run(options, readData, optionsF, optionsU);
	addpath '../mixNmatchMF/';
	options.objective = @mixNmatchMF_objective_sparse;

	[options] = optionsF(options);
	[options] = optionsU(options);

	M = readData();
	[nRows, nCols] = size(M);

	%f_all, t_opt, times_avg, times_999, memry_avg, memry_999
	[Uopt, Vopt, f_opt, f_all, t_opt, times_avg, times_999, memry_avg, memry_999] = mixNmatchMF(M, rand(nRows, options.nDims), rand(options.nDims, nCols), options);

 	% free memory
  clear M;
  clear Uopt;
  clear Vopt;
end
