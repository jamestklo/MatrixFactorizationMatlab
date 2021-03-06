function [U, V, options, t] = mixNmatchMF_update_SVRG(M, U, V, f, G_Ub, G_Vb, points, options, t)
% M 		original sparse matrix
% U			a nRows x nDims matrix 
% V			a nDims x nCols matrix
% G_Ub	a cell of b vectors, each vector is 1 x nDims; gradient of points in current batch  
% G_Vb	a cell of b vectors, each vector is nDims x 1; gradient of points in current batch
% points	array of points processed in the current batch
% options.SVRG_U			nRows x nDims sparse matrix, U matrix for re-computation 
% options.SVRG_V			nDims x nCols sparse matrix, V matrix for re-computation
% options.G_Umemory		nRows x nDims sparse matrix, full-deterministic gradient of options.SVRG_U
% options.G_Vmemory		nDims x nCols sparse matrix, full-deterministic gradient of options.SVRG_V
	[nRows, nDims] = size(U);
	[nDims, nCols] = size(V);

	batchSize = length(points);

	objectiveAt = options.objectiveAt;
	[isRegularizing, lambdaU, lambdaV] = mixNmatchMF_isRegularizing(options);
	if isRegularizing
		regularizeAt = options.regularizeAt;
	end

	if isfield(options, 'SVRG_reset')
		SVRG_reset = options.SVRG_reset;
	else
		% default is to reset for every 2*nnz(M) iterations
		SVRG_reset = 2*nnz(M);
		options.SVRG_reset = SVRG_reset;
	end

	% Here, SVRG is implemented in a way to fit the coding pattern of the mixNmatchMF framework
	if mod(t, SVRG_reset) == 1
		gU = sparse(nRows, nDims);
		gV = sparse(nDims, nCols);
		% full deterministic gradient of only non-zero entries in sparse matrix
		points = find(M);
		totalSize = length(points);
		for b=1:totalSize
			point = points(b);
			[i, j] = position(point, nRows);
			[o_f, o_gu, o_gv] = objectiveAt(M, U, V, i, j);
			if isRegularizing
				[r_f, r_gu, r_gv] = regularizeAt(U, lambdaU, V, lambdaV, i, j);
			else
				r_f = 0;
				r_gu = 0;
				r_gv = 0;
			end
			gU(i,:) = gU(i,:) + o_gu + r_gu; % 1 x nDims
			gV(:,j) = gV(:,j) + o_gv + r_gv; % nDims x 1
		end	
		gU = gU / totalSize;
		gV = gV / totalSize;
		options.G_Umemory = gU;
		options.G_Vmemory = gV;
		options.SVRG_U = U;
		options.SVRG_V = V;
	else % recompute
		gU = options.G_Umemory;
		gV = options.G_Vmemory;
		SVRG_U = options.SVRG_U;
		SVRG_V = options.SVRG_V;
		for b=1:batchSize
			point = points(b);
			[i, j] = position(point, nRows);			
			[o_f, o_gu, o_gv] = objectiveAt(M, SVRG_U, SVRG_V, i, j);
			% if regularizer is a function
			if isRegularizing
				[r_f, r_gu, r_gv] = regularizeAt(SVRG_U, lambdaU, SVRG_V, lambdaV, i, j);
			else
				r_f = 0;
				r_gu = 0;
				r_gv = 0;
			end
			gU(i,:) = gU(i,:) -o_gu -r_gu + G_Ub{b}; % 1 x nDims
			gV(:,j) = gV(:,j) -o_gv -r_gv + G_Vb{b}; % nDims x 1
		end
	end
	% stepSize < 0 for descent
	% stepSize > 0 for ascent
	stepSize = options.stepSize;
	U = U + stepSize*gU; % nRows x nDims
	V = V + stepSize*gV; % nDims x nCols
end
