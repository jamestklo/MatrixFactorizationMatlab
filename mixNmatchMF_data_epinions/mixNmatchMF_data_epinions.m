function [] = mixNmatch_data_epinions()
	addpath '../mixNmatchMF/';
	addpath '../matrixMarket/';
	addpath '../mixNmatchMF_climf/';

  options = struct;
  options.objective = @mixNmatchMF_objective_sparse;
  options.maxIter = 10000;
  options.tolerance = 0;
  options.difference = 0;

  options.batchAt = @mixNmatchMF_batchAt_random;
  options.batchSize = nRows*nCols;

  options.regularizeAt  = @mixNmatchMF_regularizeAt_L2;
  options.lambdaU = 0.001;
  options.lambdaV = options.lambdaU;

  options.update = @mixNmatchMF_update_batch;
  options.stepSize = -0.01;

	[M, nRows, nCols, entries] = mmread('../../climf/EP25_UPL5_train.mtx');
	nDims = 5;
	U = rand(nRows, nDims);
  V = rand(nDims, nCols);


  % L2 loss
	options.objectiveAt = @mixNmatchMF_lossAt_L2;
	[U, V] = mixNmatchMF(M, U, V, options);

	% climf

	
end
