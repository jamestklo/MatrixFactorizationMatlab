function [U, V, options, t] = mixNmatchMF_update_memory(M, U, V, f, G_Ub, G_Vb, points, options, t)
% U		a nRows x nDims matrix 
% V		a nDims x nCols matrix 
% G_Ub	a cell of b 1 x nDims arrays
% G_Vb	a cell of b nDims x 1 arrays
% points array of points processed in the current batch
% options.G_Umemory		nRows x nDims sparse matrix, most recent gradient
% options.G_Vmemory		nDims x nCols sparse matrix, most recent gradient
% options.SAG_U0			nRows x nDims sparse matrix, initial U matrix
% options.SAG_V0			nDims x nCols sparse matrix, initial V matrix
% options.SAG_Umemory	(nRows*nCols) x nDims sparse matrix, most recent gradient of a data point
% options.SAG_Vmemory	nDims x (nRows*nCols) sparse matrix, most recent gradient of a data point

	% default is to use zero buffer size
	batchSize = length(points);
	totalSize = nnz(M);
	if isfield(options, 'SAG_nBufs')
		SAG_nBufs = max(-1, options.SAG_nBufs);
	else
		SAG_nBufs = 0;
		options.SAG_nBufs = SAG_nBufs;
	end
	[nRows, nDims] = size(U);
	[nDims, nCols] = size(V);
	if t == 1 % reset
		options.SAG_seen = sparse(nRows, nCols);
		options.G_Umemory = sparse(nRows, nDims);
		options.G_Vmemory = sparse(nDims, nCols);
		for b=1:batchSize
			point = points(b);
			[i, j] = position(point, nRows);
			options.SAG_seen(point) = t;
			options.G_Umemory(i,:) = options.G_Umemory(i,:) + G_Ub{b}; % 1 x nDim
			options.G_Vmemory(:,j) = options.G_Vmemory(:,j) + G_Vb{b}; % nDim x 1
		end
				
		futureSize = min(batchSize*(options.maxIter-1), totalSize);
		if SAG_nBufs >= 0 && SAG_nBufs < futureSize
			options.SAG_U0 = U;
			options.SAG_V0 = V;
		end
	
	 	if SAG_nBufs > 0
			options.SAG_Umemory = sparse(nDims, nRows*nCols);
			options.SAG_Vmemory = sparse(nDims, nRows*nCols);
			if futureSize < SAG_nBufs
				SAG_nBufs = futureSize;		
				options.SAG_nBufs = SAG_nBufs;
			end
			for b=1:min(SAG_nBufs, batchSize)
				point = points(b);
				options.SAG_Umemory(:,point) = transpose(G_Ub{b}); % 1 x nDim
				options.SAG_Vmemory(:,point) = G_Vb{b}; % nDims x 1
			end
		end
				
		% randomly select future points from non-zero entries
		% sample without replacement
		points = find(M);
		for b=1:futureSize
			swap = ceil(totalSize*rand(1));
			temp = points(b);
			points(b) = points(swap);
			points(swap) = temp;
		end
		options.SAG_future = points(1:futureSize);
		
	else
		isSAGmemory = isfield(options, 'SAG_Umemory') && isfield(options, 'SAG_Vmemory');
		isUV0memory = isfield(options, 'SAG_U0') && isfield(options, 'SAG_V0');
		[isRegularizing, lambdaU, lambdaV] = mixNmatchMF_isRegularizing()
		objectiveAt = options.objectiveAt;
		if isRegularizing
			regularizeAt = options.regularizeAt;
		end

		for b=1:batchSize
			point = points(b);
			[i, j] = position(point, nRows);
			options.SAG_seen(point) = t;

			isRecomputing = true;
			if isSAGmemory
				SAG_UmemoryAt = options.SAG_Umemory(:,point);
				SAG_VmemoryAt = options.SAG_Vmemory(:,point);
				if sum(SAG_UmemoryAt) ~= 0 || sum(SAG_VmemoryAt) ~= 0
					isRecomputing = false;
					options.G_Umemory(i,:) = options.G_Umemory(i,:) - transpose(SAG_UmemoryAt) + G_Ub{b}; % 1 x nDims
					options.G_Vmemory(:,j) = options.G_Vmemory(:,j) - SAG_VmemoryAt + G_Vb{b}; % nDims x 1
				end
				if (nnz(options.SAG_Umemory)/nDims) <= SAG_nBufs
					options.SAG_Umemory(:,point) = transpose(G_Ub{b}); % nDims x 1
					options.SAG_Vmemory(:,point) = G_Vb{b}; % nDims x 1
				else % buffer is full, reset 
					options.SAG_Umemory(:,point) = zeros(nDims, 1); % nDims x 1
					options.SAG_Vmemory(:,point) = zeros(nDims, 1); % nDims x 1	 		
				end
			end

			if isRecomputing 
				if isUV0memory
					[o_f, o_gu, o_gv] = objectiveAt(M, options.SAG_U0, options.SAG_V0, i, j);
					% if regularizer is a function
					if isRegularizing
						[r_f, r_gu, r_gv] = regularizeAt(options.SAG_U0, options.lambdaU, options.SAG_V0, options.lambdaV, i, j);
					else
						r_f = 0;
						r_gu = 0;
						r_gv = 0;
					end
					options.G_Umemory(i,:) = options.G_Umemory(i,:) - o_gu - r_gu + G_Ub{b}; % 1 x nDims
					options.G_Vmemory(:,j) = options.G_Vmemory(:,j) - o_gv - r_gv + G_Vb{b}; % nDims x 1
				else % SAG-MF lazy
					options.G_Umemory(i,:) = options.G_Umemory(i,:) + G_Ub{b}; % 1 x nDims
					options.G_Vmemory(:,j) = options.G_Vmemory(:,j) + G_Vb{b}; % nDims x 1 
				end
			end
		end
	end

	if isfield(options, 'lineSearch') && 
	end
	% stepSize < 0 for descent
	% stepSize > 0 for ascent
	if isfield(options, 'SAG_seen')
		stepSize = options.stepSize/nnz(options.SAG_seen);
	else
		stepSize = options.stepSize/(t*batchSize);
	end
	U = U + stepSize*(options.G_Umemory);
	V = V + stepSize*(options.G_Vmemory);	
end
