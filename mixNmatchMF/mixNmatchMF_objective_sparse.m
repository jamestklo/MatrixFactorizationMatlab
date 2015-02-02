function [f, G_Ub, G_Vb, points] = mixNmatchMF_objectiveSparse(M, U, V, options, t)
  objectiveAt	= options.objectiveAt;
  [isRegularizing, lambdaU, lambdaV] = mixNmatchMF_isRegularizing(options);
  if isRegularizing
    regularizeAt = options.regularizeAt;
  end
  
  [points] = options.batchAt(M, options, t);
  batchSize = length(points);
  G_Ub = cell(batchSize,1);
  G_Vb = cell(batchSize,1);
  f = zeros(batchSize, 1);
  [nRows, nCols] = size(M);
  %r_f = zeros(batchSize, 1);
  parfor b=1:batchSize
    [i, j] = position(points(b), nRows);
    [f(b), G_Ub{b}, G_Vb{b}] = objectiveAt(M, U, V, i, j);

    % if regularizer is a function
    if isRegularizing
      [r_f, r_gu, r_gv] = regularizeAt(U, lambdaU, V, lambdaV, i, j);
      G_Ub{b} = G_Ub{b} + r_gu; % 1 x nDim
      G_Vb{b} = G_Vb{b} + r_gv; % nDim x 1
      f(b) = f(b) + r_f;
    end
  end
end
