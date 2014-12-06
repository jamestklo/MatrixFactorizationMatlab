function [f] = mixNmatchMF_loss_MMMF(M, U, V)
	[nRows, nDims] = size(U);
	f = 0;

	points = find(M);
	totalSize = nnz(M);
	for b=1:totalSize
		[i, j] = position(points(b), nRows);
		[o_f, o_gu, o_gv] = mixNmatchMF_lossAt_MMMF(M, U, V, i, j);
		f = f + o_f;
	end	
end
