function [] = mixNmatchMF_experiment_table(tablepath, optionsF)
	tablepath = './CLiMF';
	optionsF = @mixNmatchMF_epinions_CLiMF;
	% create new table, set up rows
	nCols = 4;
	table = cell(2, 1+nCols*6);
	save(tablepath, 'table');
	clear table;
	close all;

	addpath '../mixNmatchMF_data_epinions/';
  mixNmatchMF_experiment_row(tablepath, 'epinionsT', 1, @optionsF, @mixNmatchMF_data_epinionsTrain);
	mixNmatchMF_experiment_row(tablepath, 'epinionsS', 2, @optionsF, @mixNmatchMF_data_epinionsTest);

	clear all;
	close all;
end

function [options] = mixNmatchMF_options_SAG0(options)
	options.batchAt = @mixNmatchMF_batchAt_random;
	options.batchSize = -1;
	options.update = @mixNmatchMF_update_memory;
end

function [] = mixNmatchMF_experiment_row(tablepath, rowname, rowAt, optionsF, readData);
	load(tablepath);
	table{rowAt, 1} = rowname;
	save(tablepath, 'table');
	close all;
  clear table;

	addpath '../mixNmatchMF/';

	% Full: colAt=1 
  mixNmatchMF_experiment_run(@readData, @optionsF, @mixNmatchMF_options_FullGD, tablepath, rowAt, 1);

	% Stochastic: colAt=2
  mixNmatchMF_experiment_run(@readData, @optionsF, @mixNmatchMF_options_StochasticGD, tablepath, rowAt, 2);

	% SAG0: colAt = 3;
	% mixNmatchMF_experiment_run(@readData, @optionsF, @mixNmatchMF_options_SAG0, tablepath, rowAt, 3);
end


function [] = mixNmatchMF_experiment_run(readData, optionsF, optionsU, filepath, rowAt, colAt)
	addpath '../mixNmatchMF/';
	options = struct;
	options.objective = @mixNmatchMF_objective_sparse;
	options.maxIter = 10000;

	[options] = optionsF(options);
	[options] = optionsU(options);

	%f_all, t_opt, times_avg, times_999, memry_avg, memry_999
	[Uopt, Vopt, f_opt, f_all, t_opt, times_avg, times_999, memry_avg, memry_999] 
		= mixNmatchMF(readData(), rand(nRows, options.nDims), rand(options.nDims, nCols), options);

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
  nCols = 4;

  % add f_all
  table{rowAt, 1+0*nCols+colAt} = f_all;

  % add t_opt
  table{rowAt, 1+1*nCols+colAt} = t_opt;

  % add times_avg
  table{rowAt, 1+2*nCols+colAt} = times_avg;

  % add times_999
  table{rowAt, 1+3*nCols+colAt} = times_999;

  % add memry_avg
  table{rowAt, 1+4*nCols+colAt} = memry_avg;

  % add memry_999
  table{rowAt, 1+5*nCols+colAt} = memry_999;

  % write data to file
  save(filepath, 'table');
end
