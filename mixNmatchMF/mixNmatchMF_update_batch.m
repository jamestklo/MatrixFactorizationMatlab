function [U, V, options, t] = mixNmatchMF_update_batch(M, U, V, f, G_Ub, G_Vb, points, options, t)
  batchSize = length(points);
  if batchSize > 0
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
    if isfield(options, 'lineSearch') && isa(options.lineSearch, 'function_handle')
      [stepSizeU, stepSizeV, t] = options.lineSearch(M, U, V, f, G_Ub, G_Vb, points, options, t);
    elseif isfield(options, 'stepSize')
      stepSizeU = options.stepSize;
      stepSizeV = stepSizeU;
    end

    if isfield(options, 'SAG_seen')
      totalSize = nnz(optionns.SAG_seen);
    else
      totalSize = t*batchSize;
    end
    U = U + stepSizeU*(G_U)/batchSize;
    V = V + stepSizeV*(G_V)/batchSize;
  end
end
