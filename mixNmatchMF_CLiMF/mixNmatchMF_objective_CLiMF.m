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
