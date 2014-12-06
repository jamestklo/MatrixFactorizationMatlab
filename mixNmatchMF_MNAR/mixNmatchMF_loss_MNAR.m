function [f] = mixNmatchMF_loss_MNAR(M, U, V)
	[nRows, nCols] = size(M);
	f = 0;
	for i=1:nRows
		for j=1:nCols
			[o_f, o_gu, o_gv] = mixNmatchMF_lossAt_MNAR(M, U, V, i, j);
			f = f + o_f;
		end
	end	
end
