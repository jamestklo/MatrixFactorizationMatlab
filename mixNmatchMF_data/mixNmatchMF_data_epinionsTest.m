function [M, nRows, nCols] = mixNmatchMF_data_epinionsTest()
	addpath '../matrixMarket/';
	[M, nRows, nCols] = mmread('../../climf/EP25_UPL5_test.mtx');
	size(M)
	nnz(M)    
end
