function [] = mixNmatchMF_test()
  %regularizeAt_L2_test();
  %lossAt_L2_test();
  %batchAt_test();
  %position_test();
  %objectiveSparse_test();
  %updateBatch_test();
  main_test();
end

function [M] = synthesizeMatrix(nPoints, density, minM, maxM)
  nTotal = ceil(nPoints / density);
  nRows = sqrt(nTotal)*rand(1);
  nCols = ceil(nTotal/nCols);
  M = sparse(nRows, nCols);
  for b=nPoints
    M(nTotal*rand(1)) = minM + round((maxM - minM)*rand(1));
  end
end
  
function [] = regularizeAt_L2_test()
  nRows = 10;
  nCols = 20;
  nDims = 4;
  lambdaU = 0.0001;
  lambdaV = lambdaU;

  U = rand(nRows, nDims);
  V = rand(nDims, nCols);
  i = ceil(nRows*rand(1));
  j = ceil(nCols*rand(1));
  [f, gu, gv] = mixNmatchMF_regularizeAt_L2(U, lambdaU, V, lambdaV, i, j);
end

function [] = lossAt_L2_test()
  nRows = 10;
  nCols = 20;
  nDims = 2;

  M = rand(nRows, nCols);
  U = rand(nRows, nDims);
  V = rand(nDims, nCols);
  i = ceil(nRows*rand(1));
  j = ceil(nCols*rand(1));
  [f, gu, gv] = mixNmatchMF_lossAt_L2(M, U, V, i, j)
end

function [] = batchAt_test()
  nRows = 10;
  nCols = 20;
  M = rand(nRows, nCols);
  t = 1;
  options = struct;
  [points] = mixNmatchMF_batchAt_random(M, options, t);
end

function [] = position_test()
  nRows = 10;
  nCols = 20;
  for p=1:(nRows*nCols)
    [i, j] = position(p, nRows);
	  fprintf('position_test() %d=(%d, %d)\n', p, i, j);
  end  
end

function [] = objectiveSparse_test()
  nRows = 10;
  nCols = 20;
  nDims = 4;
  
  options	= struct;
  options.objectiveAt = @mixNmatchMF_lossAt_L2;
  options.regularizeAt = @mixNmatchMF_regularizeAt_L2;
  options.batchAt = @mixNmatchMF_batchAt_random;
  options.lambdaU = 0.0001;
  options.lambdaV = options.lambdaU;
  
  M = rand(nRows, nCols);
  U = rand(nRows, nDims);
  V = rand(nDims, nCols);
  t = 1;
  [f, G_Ub, G_Vb, points] = mixNmatchMF_objective_sparse(M, U, V, options, t);
  for b=1:length(points);
    p = points(b);
    [i, j] = position(p, nRows);
    fprintf('objectiveSparse_test() %d=(%d, %d)\n', p, i, j);
  end  
end

function [] = updateBatch_test()
  nRows = 10;
  nCols = 20;
  nDims = 4;

  options	= struct;
  options.objectiveAt	= @mixNmatchMF_lossAt_L2;
  options.regularizeAt	= @mixNmatchMF_regularizeAt_L2;
  options.batchAt	= @mixNmatchMF_batchAt_random;
  options.lambdaU = 0.0001;
  options.lambdaV = options.lambdaU;
  
  M = rand(nRows, nCols);
  U = rand(nRows, nDims);
  V = rand(nDims, nCols);
  t = 1;
  [f, G_Ub, G_Vb, points] = mixNmatchMF_objective_sparse(M, U, V, options, t);
  [U, V] = mixNmatchMF_update_batch(M, U, G_Ub, V, G_Vb, points, options, t);
end

function [] = main_test()
  nRows = 100;
  nCols = 200;
  nDims = 5;
  M = ones(nRows, nCols);
  U = rand(nRows, nDims);
  V = rand(nDims, nCols);

  options = struct;
  options.objective = @mixNmatchMF_objective_sparse;
  options.maxIter = 10000;
  options.tolerance = 0;
  options.difference = 0;

  options.batchAt = @mixNmatchMF_batchAt_random;
  options.batchSize = nRows*nCols;

  options.objectiveAt = @mixNmatchMF_lossAt_L2;

  options.regularizeAt  = @mixNmatchMF_regularizeAt_L2;
  options.lambdaU = 0.001;
  options.lambdaV = options.lambdaU;

  options.update = @mixNmatchMF_update_batch;
  options.stepSize = -0.01;

  [U, V] = mixNmatchMF(M, U, V, options);
end
