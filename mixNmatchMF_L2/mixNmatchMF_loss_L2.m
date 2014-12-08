function [f] = mixNmatchMF_loss_L2sparse(M, U, V)
	[nRows, nDims] = size(U);
	points = find(M);
	totalSize = nnz(M);
	o_f = zeros(totalSize, 1);
	parfor b=1:totalSize
		[i, j] = position(points(b), nRows);
		[o_f(b), o_gu, o_gv] = mixNmatchMF_objectiveAt_L2(M, U, V, i, j);
	end
	f = mean(o_f);
end

function [f] = mixNmatchMF_loss_L2dense(M, U, V)
  f  = 0 + mean(mean((M-U*V).^2));
end
