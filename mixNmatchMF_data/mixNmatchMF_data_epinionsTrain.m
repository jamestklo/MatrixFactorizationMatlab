function [M, nRows, nCols] = mixNmatchMF_data_epinionsTrain()
	addpath '../matrixMarket/';
	[M, nRows, nCols] = mmread('../../climf/EP25_UPL5_train.mtx');
	size(M)
	nnz(M)
end
