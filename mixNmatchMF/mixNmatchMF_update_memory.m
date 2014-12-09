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

	% default is to use zero buffer size
  if isfield(options, 'SAG_nBufs')
    SAG_nBufs = max(0, options.SAG_nBufs);
  else
    SAG_nBufs = 0;
    options.SAG_nBufs = SAG_nBufs;
  end

  [nRows, nDims] = size(U);
  [nDims, nCols] = size(V);

  batchSize = length(points);
  totalSize = nnz(M);
	if t == 1
  	options.SAG_seen = sparse(nRows, nCols);

  	% the most recent gradients
    options.G_Umemory = sparse(nRows, nDims);
    options.G_Vmemory = sparse(nDims, nCols);
    for b=1:batchSize
      [i, j] = position(points(b), nRows);
      options.G_Umemory(i,:) = options.G_Umemory(i,:) + G_Ub{b}; % 1 x nDim
      options.G_Vmemory(:,j) = options.G_Vmemory(:,j) + G_Vb{b}; % nDim x 1
    end

 		if SAG_nBufs < totalSize
    	options.SAG_U0 = U;
      options.SAG_V0 = V;
    end
  
	 	if SAG_nBufs > 0
    	options.SAG_Umemory = sparse(nDims, nRows*nCols);
    	options.SAG_Vmemory = sparse(nDims, nRows*nCols);

    	for b=1:SAG_nBufs
    		point = points(b);
      	options.SAG_Umemory(:,point) = transpose(G_Ub{b}); % 1 x nDim
      	options.SAG_Vmemory(:,point) = G_Vb{b}; % nDims x 1
    	end
    end
  else
  	for b=1:batchSize
  		point = points(b);
  		[i, j] = position(point, nRows);
  		options.SAG_seen(point) = t;

  		isRecomputing = true;
  		if isa(options, 'SAG_Umemory') && isa(options, 'SAG_Vmemory')
	    	if sum(options.SAG_Umemory(:,point)) ~= 0 || sum(options.SAG_Vmemory(:,point)) ~= 0
	    		isRecomputing = false;
	      	options.G_Umemory(i,:) = options.G_Umemory(i,:) - transpose(options.SAG_Umemory(:,point)) + G_Ub{b}; % 1 x nDims
	      	options.G_Vmemory(:,j) = options.G_Vmemory(:,j) - options.SAG_Vmemory(:,point) + G_Vb{b}; % nDims x 1
	      end
	      options.SAG_Umemory(:,point) = transpose(G_Ub{b}); % nDims x 1
      	options.SAG_Vmemory(:,point) = G_Vb{b}; % nDims x 1
  		end
  		if isRecomputing
        [o_f, o_gu, o_gv] = options.objectiveAt(M, options.SAG_U0, options.SAG_V0, i, j);
        [r_f, r_gu, r_gv] = options.regularizeAt(options.SAG_U0, options.lambdaU, options.SAG_V0, options.lambdaV, i, j);
	      options.G_Umemory(i,:) = options.G_Umemory(i,:) - o_gu - r_gu + G_Ub{b}; % 1 x nDims
	      options.G_Vmemory(:,j) = options.G_Vmemory(:,j) - o_gv - r_gv + G_Vb{b}; % nDims x 1
  		end
    end
  end

	% stepSize < 0 for descent
  % stepSize > 0 for ascent
	if t == 1
  	stepSize = options.stepSize/batchSize;
  else
    stepSize = options.stepSize/nnz(options.SAG_seen);
  end
  U = U + stepSize*(options.G_Umemory);
  V = V + stepSize*(options.G_Vmemory);  
end
