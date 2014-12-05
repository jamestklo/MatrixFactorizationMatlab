function [U, V] = mixNmatchMF_update_batch(M, U, G_Ub, V, G_Vb, points, options, t)
  batchSize = length(points);
  if batchSize > 0
    if isfield(options, 'stepSize')
      stepSize = options.stepSize;
    else 
      stepSize = -0.0001;
      options.StepSize = stepSize;
	end
    [nRows, nDims] = size(U);
    [nDims, nCols] = size(V);
    G_U = sparse(nRows, nDims);
    G_V = sparse(nDims, nCols);
    for b=1:batchSize
      [i, j] = position(points(b), nRows);
      G_U(i,:) = G_U(i,:) + G_Ub{b}; % 1 x nDim
      G_V(:,j) = G_V(:,j) + G_Vb{b}; % nDim x 1
    end
    % stepSize < 0 for descent
    % stepSize > 0 for ascent
    stepSize = stepSize/batchSize;
    U = U + stepSize*G_U;
    V = V + stepSize*G_V;
  end
end
