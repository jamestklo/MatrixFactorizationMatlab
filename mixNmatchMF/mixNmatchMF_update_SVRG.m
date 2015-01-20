% Slide 13 of http://cikm2014.fudan.edu.cn/cikm2014/Tpl/Public/slides/ZhangTongTalk.pdf
function [U, V, options] = mixNmatchMF_update_SVRG(M, U, G_Ub, V, G_Vb, points, options, t)
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

	if isfield(options, 'lambdaU')
		lambdaU = options.lambdaU;
	else
		lambdaU = 0;
	end
	if isfield(options, 'lambdaV')
		lambdaV = options.lambdaV;	
	else
		lambdaV = 0;
	end
	

	% Here, SVRG is implemented in a way to fit the coding pattern of the mixNmatchMF framework
	%if isReset % do a full deterministic gradient 	
	if t == 1
		gU = sparse(nRows, nDims);
		gV = sparse(nDims, nCols);
		% full deterministic gradient of only non-zero entries in sparse matrix
		points = find(M);
		totalSize = length(points);
		for b=1:totalSize
			point = points(b);
			[i, j] = position(point, nRows);
			[o_f, o_gu, o_gv] = options.objectiveAt(M, U, V, i, j);
			if lambdaU ~= 0 || lambdaV ~= 0
				[r_f, r_gu, r_gv] = options.regularizeAt(U, lambdaU, V, lambdaV, i, j);
			else
				r_f = 0;
				r_gu = 0;
				r_gv = 0;
			end
			gU(i,:) = gU(i,:) + o_gu + r_gu; % 1 x nDims
			gV(:,j) = gV(:,j) + o_gv + r_gv; % nDims x 1
		end	
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
			[o_f, o_gu, o_gv] = options.objectiveAt(M, SVRG_U, SVRG_V, i, j);
			% if regularizer is a function
			if lambdaU ~= 0 || lambdaV ~= 0
				[r_f, r_gu, r_gv] = options.regularizeAt(SVRG_U, lambdaU, SVRG_V, lambdaV, i, j);
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
	stepSize = options.stepSize/batchSize;	
	U = U + stepSize*gU; % nRows x nDims
	V = V + stepSize*gV; % nDims x nCols
end
