function [] = mixNmatchMF_test()
  %regularizeL2at_test();
  %lossL2at_test();
  %batchAt_test();
  %position_test();
  %objectiveSparse_test();
  updateBatch_test()
end

function [M] = synthesizeMatrix(nPoints, density, min, max)
  nTotal = ceil(nPoints / density);
  nRows = sqrt(nTotal)*rand(1);
  nCols = ceil(nTotal/nCols);
  M = sparse(nRows, nCols);
  for b=nPoints
    M(nTotal*rand(1)) = min + round((max - min)*rand(1));
  end
end

function [] = regularizeL2at_test()
  nRows = 10;
  nCols = 20;
  nDims = 4;
  lambda = 0.0001;
  
  U = rand(nRows, nDims);
  V = rand(nDims, nCols);
  i = ceil(nRows*rand(1));
  j = ceil(nCols*rand(1));
  [f, gu, gv] = regularizeL2at(lambda, U, V, i, j);
end

function [] = lossL2at_test()
  nRows = 10;
  nCols = 20;
  nDims = 4;

  M = rand(nRows, nCols);  
  U = rand(nRows, nDims);
  V = rand(nDims, nCols);
  i = ceil(nRows*rand(1));
  j = ceil(nCols*rand(1));
  [f, gu, gv] = lossL2at(M, U, V, i, j);
end

function [] = batchAt_test()
  nRows = 10;
  nCols = 20;
  M = rand(nRows, nCols);
  t = 1;
  options = struct;
  [points] = mixNmatchMF_batchAt_random10(M, options, t)
end

function [] = position_test()
  nRows = 10;
  nCols = 20;
  for p=1:(nRows*nCols)
    [i, j] = position(p, nRows);
	fprintf('%d=(%d, %d)\n', p, i, j);
  end  
end

function [] = objectiveSparse_test()
  nRows = 10;
  nCols = 20;
  nDims = 4;
  
  options				= struct;
  options.objectiveAt	= @lossL2at;
  options.regularizeAt	= @regularizeL2at;
  options.batchAt		= @mixNmatchMF_batchAt_random10;
  options.lambda		= 0.0001;
  
  M = rand(nRows, nCols);
  U = rand(nRows, nDims);
  V = rand(nDims, nCols);
  t = 1;
  [F, G_Ub, G_Vb, points] = mixNmatchMF_objective_sparse(M, U, V, options, t)
  for b=1:length(points);
    p = points(b);
    [i, j] = position(p, nRows);
	%fprintf('%d=(%d, %d)\n', p, i, j);
  end  
end

function [] = updateBatch_test()
  nRows = 10;
  nCols = 20;
  nDims = 4;
  
  options				= struct;
  options.objectiveAt	= @lossL2at;
  options.regularizeAt	= @regularizeL2at;
  options.batchAt		= @mixNmatchMF_batchAt_random10;
  options.lambda		= 0.0001;
  
  M = rand(nRows, nCols);
  U = rand(nRows, nDims);
  V = rand(nDims, nCols);
  t = 1;
  [F, G_Ub, G_Vb, points] = mixNmatchMF_objective_sparse(M, U, V, options, t);
  [U, V] = mixNmatchMF_update_batch(U, G_Ub, V, G_Vb, points, options, t)
end
