function [results, labels] = mixNmatchMF_experiment_start(data, num)
  results = cell(length(data), 1);
  labels  = cell(length(data), 1);

  if isa(@matlabpool, 'function_handle')
    matlabpool(num);
  elseif isa(@parpool, 'function_handle')
    parpool(num);
  end
  
  % parallel execution
  parfor d=1:length(results)
    if length(data{d}) > 0
      labels{d}  = data{d}{1};
      results{d} = mixNmatchMF_experiment_gradients(data{d}{2}, data{d}{3}, data{d}{4});
    end
  end
end


function [gradients] = mixNmatchMF_experiment_gradients(options, optionsF, readData)
  addpath '../mixNmatchMF/';

  gradients = cell(4, 1);
  gradients{1} = @mixNmatchMF_options_FullGD;      
  gradients{2} = @mixNmatchMF_options_StochasticGD; 
  %gradients{3} = @mixNmatchMF_options_SAG0;
  %gradients{4} = @mixNmatchMF_options_SAGbuffered;

  parfor g=1:length(gradients)
    if isa(gradients{g}, 'function_handle')
      gradients{g} = mixNmatchMF_experiment_run(options, readData, optionsF, gradients{g});
    end
  end
end


function [options] = mixNmatchMF_options_FullGD(options)
	options.batchAt = @mixNmatchMF_batchAt_random;
	options.batchSize = 0;
	options.update = @mixNmatchMF_update_batch;
end


function [options] = mixNmatchMF_options_StochasticGD(options)
	options.batchAt = @mixNmatchMF_batchAt_random;
	options.batchSize = 1;
	options.update = @mixNmatchMF_update_batch;
end


function [options] = mixNmatchMF_options_SAG0(options)
	options.batchAt = @mixNmatchMF_batchAt_random;
	options.batchSize = -1;
	options.update = @mixNmatchMF_update_memory;
end


function [options] = mixNmatchMF_options_SAGbuffered(options)
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