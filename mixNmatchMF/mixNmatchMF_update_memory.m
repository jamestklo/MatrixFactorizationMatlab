function [U, V, options] = mixNmatchMF_update_memory(M, U, G_Ub, V, G_Vb, points, options, t)
% U		a nRows x nDims matrix 
% V		a nDims x nCols matrix
% G_Ub	a cell of b 1 x nDims arrays
% G_Vb	a cell of b nDims x 1 arrays
% points array of points processed in the current batch
% options.G_Umemory		nRows x nDims sparse matrix
% options.G_Vmemory		nDims x nCols sparse matrix
% options.SAG_U0        nRows x nDims sparse matrix, initial U matrix
% options.SAG_V0        nDims x nCols sparse matrix, initial V matrix
% options.SAG_Umemory   (nRows*nCols) x nDims sparse matrix
% options.SAG_Vmemory   nDims x (nRows*nCols) sparse matrix
  batchSize = length(points);
  if isfield(options, 'SAG_mode')
    SAG_mode = max(0, options.SAG_mode);
  else
    SAG_mode = 0;
    options.SAG_mode = SAG_mode;
  end
  [nRows, nDims] = size(U);
  [nDims, nCols] = size(V);
  if t == 1
    %options.SAG_Umemory = sparse(nRows*nCols, nDims);
    %options.SAG_Vmemory = sparse(nDims, nRows*nCols);
    options.G_Umemory   = sparse(nRows, nDims);
    options.G_Vmemory   = sparse(nDims, nCols);
    for b=1:batchSize
      [i, j] = position(points(b), nRows);
      options.G_Umemory(i,:) = options.G_Umemory(i,:) + G_Ub{b}; % 1 x nDim
      options.G_Vmemory(:,j) = options.G_Vmemory(:,j) + G_Vb{b}; % nDim x 1
    end
  end
  if batchSize > 0
    if (SAG_mode < 2) && (t == 1)
      options.SAG_U0 = U;
      options.SAG_V0 = V;      
      if (SAG_mode == 1) 
          
      end
    else
	    for b=1:batchSize
	      point = points(b);
	      [i, j] = position(point, nRows);
	      % take the old one away, put the new one in
        if false && (options.SAG_Umemory(point,:)) % if point exists in memory
	        options.G_Umemory(i,:) = options.G_Umemory(i,:) - options.SAG_Umemory(point,:) + G_Ub{b}; % 1 x nDims
	        options.G_Vmemory(:,j) = options.G_Vmemory(:,j) - options.SAG_Vmemory(:,point) + G_Vb{b}; % nDims x 1
        elseif SAG_mode == 0 % re-compute the initial f, gu gv
          [o_f, o_gu, o_gv] = options.objectiveAt(M, options.SAG_U0, options.SAG_V0, i, j);
          [r_f, r_gu, r_gv] = options.regularizeAt(options.SAG_U0, options.lambdaU, options.SAG_V0, options.lambdaV, i, j);
	        options.G_Umemory(i,:) = options.G_Umemory(i,:) - o_gu - r_gu + G_Ub{b}; % 1 x nDims
	        options.G_Vmemory(:,j) = options.G_Vmemory(:,j) - o_gv - r_gv + G_Vb{b}; % nDims x 1
        %elseif SAG_mode == 1
          %[r_f, r_gu, r_gv] = options.regularizeAt(options.lambda, options.SAG_U0, options.SAG_V0, i, j);
	        %options.G_Umemory(i,:) = options.G_Umemory(i,:) - ((options.SAG_V0)')*G(i,j) - r_gu + G_Ub{b}; % 1 x nDims
	        %options.G_Vmemory(:,j) = options.G_Vmemory(:,j) - ((options.SAG_U0)')*G(i,j) - r_gv + G_Vb{b}; % nDims x 1          
        end
      end
      %options.SAG_Umemory(point,:) = G_Ub{b}; % 1 x nDims
      %options.SAG_Vmemory(:,point) = G_Vb{b}; % nDims x 1
    end
    % stepSize < 0 for descent
    % stepSize > 0 for ascent
    stepSize = -0.0001;
	  stepSize = stepSize/t;
    U = U + stepSize*(options.G_Umemory);
    V = V + stepSize*(options.G_Vmemory);
  end  
end
