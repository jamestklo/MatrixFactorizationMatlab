function [] = mixNmatchMF_experiment_row(tablepath, rowAt, options, optionsF, readData);
	addpath '../mixNmatchMF/';

	% Full: colAt=1 
  mixNmatchMF_experiment_run(options, readData, optionsF, @mixNmatchMF_options_FullGD, tablepath, rowAt, 1);

	% Stochastic: colAt=2
  mixNmatchMF_experiment_run(options, readData, optionsF, @mixNmatchMF_options_StochasticGD, tablepath, rowAt, 2);

	% SAG0: colAt = 3;
	% mixNmatchMF_experiment_run(@readData, @optionsF, @mixNmatchMF_options_SAG0, tablepath, rowAt, 3);
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


function [] = mixNmatchMF_experiment_run(options, readData, optionsF, optionsU, filepath, rowAt, colAt)
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

  % save data
  mixNmatchMF_experiment_add(filepath, rowAt, colAt, f_all, t_opt, times_avg, times_999, memry_avg, memry_999);
end


function [] = mixNmatchMF_experiment_add(filepath, rowAt, colAt, f_all, t_opt, times_avg, times_999, memry_avg, memry_999)
  % read data from file
  load(filepath);
  [tRows, tCols] = size(table);
  tCols = round( (tCols-1)/6 );

  % add f_all
  table{rowAt, 1+0*tCols+colAt} = f_all;

  % add t_opt
  table{rowAt, 1+1*tCols+colAt} = t_opt;

  % add times_avg
  table{rowAt, 1+2*tCols+colAt} = times_avg;

  % add times_999
  table{rowAt, 1+3*tCols+colAt} = times_999;

  % add memry_avg
  table{rowAt, 1+4*tCols+colAt} = memry_avg;

  % add memry_999
  table{rowAt, 1+5*tCols+colAt} = memry_999;

  % write data to file
  save(filepath, 'table');
end
