function [subA] = mixNmatchMF_data_LiveJournal()
	%load '../mixNmatchMF_data_mat/subset_ljournal-2008.mat';
	% Problem.A(1:5000, 1:5000);
	load '../mixNmatchMF_data_ProblemA/ljournal-2008.mat';
	size(subA)
	nnz(subA)
end
