function [f] = mixNmatch_objective_CLiMF(Y, U, V)
	[nRows, nDims] = size(U);
	f = 0;

	points = find(Y);
	totalSize = nnz(Y);
	for b=1:totalSize
		[i, j] = position(points(b), nRows);
		[o_f, o_gu, o_gv] = mixNmatchMF_objectiveAt_climf(Y, U, V, i, j);
		f = f + o_f;
	end
end
