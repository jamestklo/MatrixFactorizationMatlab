function [f, G_Ub, G_Vb, points] = mixNmatchMF_objectiveSparse(M, U, V, options, t)
  objectiveAt	= options.objectiveAt;
  regularizeAt	= options.regularizeAt;
  isRegularizing = 
  batchAt		= options.batchAt;
 
  lambdaU = options.lambdaU;
  lambdaV	= options.lambdaV;  
  
  [nRows, nCols] = size(M);
  f = 0;
 
  [points] = batchAt(M, options, t);
  batchSize = length(points);
  G_Ub = cell(batchSize,1);
  G_Vb = cell(batchSize,1);
	
  for b=1:batchSize
    [i, j] = position(points(b), nRows);
    [o_f, G_Ub{b}, G_Vb{b}] = objectiveAt(M, U, V, i, j);
    f = f + o_f;

    % if regularizer is a function
    if isRegularizing
      [r_f, r_gu, r_gv] = regularizeAt(U, lambdaU, V, lambdaV, i, j);
      f = f + r_f;
      G_Ub{b} = G_Ub{b} + r_gu; % 1 x nDim
      G_Vb{b} = G_Vb{b} + r_gv; % nDim x 1
    end
  end
  f = f/batchSize;
end
