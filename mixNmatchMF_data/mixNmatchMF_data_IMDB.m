function [subA] = mixNmatchMF_data_IMDB()
	load '../mixNmatchMF_mat/subset_IMDB.mat';
	%subA = mixNmatchMF_data_subDim(Problem.A, 25000, 25000, 1, 1);
	size(subA)
	nnz(subA)
end
