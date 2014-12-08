function [f, gu, gv] = mixNmatchMF_lossAt_MMMF(M, U, V, i, j)
	Ui = U(i,:); % 1 x nDim
	Ui_transposed = Ui';
	Vj = V(:,j); % nDim x 1
	
	f = 0;
	gu = 0;
	gv = 0;
	[nDims, nCols] = size(V);
	parfor k=1:nCols
		if k ~= j
			Vdif = Vj - V(:,k);
			temp = 1 - Ui*Vdif;
			if temp > 0
				f = f + temp;
				gu = gu - Vdif';
				gv = gv - Ui_transposed;
			end
		end
	end
end 
