function [f] = mixNmatch_objectiveAll_sparse_parallel(M, U, V, objectiveAt)
	[nRows, nDims] = size(U);
	points = find(M);
	totalSize = nnz(M);
	o_f = zeros(totalSize, 1);
	parfor b=1:totalSize
		[i, j] = position(points(b), nRows);
		[o_f(b), o_gu, o_gv] = objectiveAt(M, U, V, i, j);
	end
	f = mean(o_f);
end

function [f] = mixNmatch_objectiveAll_sparse_sequential(M, U, V, objectiveAt)
	[nRows, nDims] = size(U);
	points = find(M);
	f = 0;
	totalSize = nnz(M);
	for b=1:totalSize
		[i, j] = position(points(b), nRows);
		[o_f, o_gu, o_gv] = objectiveAt(M, U, V, i, j);
		f = f + o_f;
	end
	f = f/totalSize;
end
