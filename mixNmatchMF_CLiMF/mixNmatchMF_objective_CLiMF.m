function [f] = mixNmatch_objective_CLiMF(Y, U, V)
	[nRows, nDims] = size(U);
	points = find(Y);
	totalSize = nnz(Y);
	o_f = zeros(totalSize, 1);
	parfor b=1:totalSize
		[i, j] = position(points(b), nRows);
		[o_f(b), o_gu, o_gv] = mixNmatchMF_objectiveAt_CLiMF(Y, U, V, i, j);
	end
	f = mean(o_f);
end

function [f] = mixNmatch_objective_CLiMFsequential(Y, U, V)
	[nRows, nDims] = size(U);
	points = find(Y);
	f = 0;
	totalSize = nnz(Y);
	for b=1:totalSize
		[i, j] = position(points(b), nRows);
		[o_f, o_gu, o_gv] = mixNmatchMF_objectiveAt_CLiMF(Y, U, V, i, j);
		f = f + o_f;
	end
	f = f/totalSize;
end

