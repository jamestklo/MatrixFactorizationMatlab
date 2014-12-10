function [subA] = mixNmatchMF_data_Wikipedia()
	%load '../mixNmatchMF_data_mat/subset_wikipedia-20070206.mat';
	%M = mixNmatchMF_data_subDim(Problem.A, 5000, 5000, 1, 1);

	load '../mixNmatchMF_data_ProblemA/wikipedia-20070206.mat';
	size(subA)
	nnz(subA)
end
