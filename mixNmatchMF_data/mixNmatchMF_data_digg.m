function [M] = mixNmatchMF_data_digg()
	load '../mixNmatchMF_mat/digg12month1.mat';
	M = mixNmatchMF_data_subDim(Problem.A, 1000, 1000, 1, 1);
	size(M)
	nnz(M)
end
