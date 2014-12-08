function [Msub] = mixNmatchMF_data_subDim(M, subRows, subCols, startRows, startCols)
	[nRows, nCols] = size(M);
	subRows = min(abs(subRows), nRows);
	subCols = min(abs(subCols), nCols);

	if startRows <= 0
		startRows = ceil(rand(1)*abs(1+nRows-subRows));
	end
	if startCols <= 0
		startCols = ceil(rand(1)*abs(1+nCols-subCols));
	end
	Msub = M( startRows:(startRows + subRows), startCols:(startCols + subCols) );
end
