function [f, G_Ub, G_Vb, points] = mixNmatchMF_objectiveSparse(M, U, V, options, t)
  objectiveAt	= options.objectiveAt;
  if isfield(options, 'regularizeAt') 
    regularizeAt = options.regularizeAt;
    lambdaU = options.lambdaU;
    lambdaV = options.lambdaV;  
  else
    lambdaU = 0;
    lambdaV = 0;
  end
  
  batchAt		= options.batchAt;
  
  [nRows, nCols] = size(M);
 
  [points] = batchAt(M, options, t);
  batchSize = length(points);
  G_Ub = cell(batchSize,1);
  G_Vb = cell(batchSize,1);
  o_f = zeros(batchSize, 1);
  r_f = zeros(batchSize, 1);
  parfor b=1:batchSize
    [i, j] = position(points(b), nRows);
    [o_f(b), G_Ub{b}, G_Vb{b}] = objectiveAt(M, U, V, i, j);

    % if regularizer is a function
    if lambdaU ~= 0 || lambdaV ~= 0
      [r_f(b), r_gu, r_gv] = regularizeAt(U, lambdaU, V, lambdaV, i, j);
      G_Ub{b} = G_Ub{b} + r_gu; % 1 x nDim
      G_Vb{b} = G_Vb{b} + r_gv; % nDim x 1
    end
  end
  f = mean(o_f) + mean(r_f);
end
