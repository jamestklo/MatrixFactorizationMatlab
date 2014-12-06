function [] = mixNmatch_data_epinions()
	mixNmatch_data_epinions1();
end

function [] = mixNmatch_data_epinions2()
	addpath '../mixNmatchMF/';
	addpath '../matrixMarket/';
	addpath '../mixNmatchMF_climf/';

	[M, nRows, nCols, entries] = mmread('../../climf/EP25_UPL5_train.mtx');
	nDims = 5;
	U = rand(nRows, nDims);
  V = rand(nDims, nCols);

  tic;
  f = mixNmatchMF_loss_L2(M, U, V)
  toc;
end

function [] = mixNmatch_data_epinions1()
	addpath '../mixNmatchMF/';
	addpath '../matrixMarket/';
	addpath '../mixNmatchMF_climf/';

  options = struct;
  options.objective = @mixNmatchMF_objective_sparse;
  options.maxIter = 10000;
  options.tolerance = 0;
  options.difference = 0;

  options.batchAt = @mixNmatchMF_batchAt_random;
  options.batchSize = 1;

  %options.regularizeAt = @mixNmatchMF_regularizeAt_L2;
  %options.lambdaU = 0.001;
  %options.lambdaV = options.lambdaU;

  options.update = @mixNmatchMF_update_batch;

	[M, nRows, nCols, entries] = mmread('../../climf/EP25_UPL5_train.mtx');
	nDims = 5;
	U = rand(nRows, nDims);
  V = rand(nDims, nCols);

  % L2 loss
  %[options] = mixNmatch_epinions_L2(options);

	% climf
	%[options] = mixNmatch_epinions_climf(options);

	% WR-MF
  %[options] = mixNmatch_epinions_WRMF(options);  

	[U, V] = mixNmatchMF(M, U, V, options);
end

function [options] = mixNmatch_epinions_L2(options) 
  addpath '../mixNmatchMF_L2/';
  options.objectiveAll = @mixNmatchMF_loss_L2;
	options.objectiveAt = @mixNmatchMF_lossAt_L2;
	% stochastic gradient descent
	options.stepSize = -0.01;
end

function [options] = mixNmatch_epinions_WRMF(options) 
  addpath '../mixNmatchMF_WRMF/';
  options.objectiveAll = @mixNmatchMF_loss_WRMF;
	options.objectiveAt = @mixNmatchMF_lossAt_WRMF;
	% stochastic gradient descent
	options.stepSize = -0.01;
end

function [options] = mixNmatch_epinions_CLiMF(options)
	addpath '../mixNmatchMF_CLiMF/';
	options.objectiveAll = @mixNmatchMF_objective_CLiMF;
	options.objectiveAt = @mixNmatchMF_objectiveAt_CLiMF;
	% stochastic gradient ascent
	options.stepSize = +0.01;
end
