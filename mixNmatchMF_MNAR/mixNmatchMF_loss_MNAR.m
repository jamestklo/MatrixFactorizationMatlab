function [f] = mixNmatchMF_loss_MNAR(M, U, V)
	[nRows, nCols] = size(M);
	f = 0;
	for j=1:nCols
		f_i = zeros(nRows, 1);
		parfor i=1:nRows
			[f_i(j), o_gu, o_gv] = mixNmatchMF_lossAt_MNAR(M, U, V, i, j);
		end
		f = f + sum(f_i);
	end	
end
