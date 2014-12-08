function [M] = mixNmatchMF_data_IMDB()
	load 'C:\Temp\cs534L-SAGmf\cs534L-IMDB.mat';
	M = mixNmatchMF_data_subDim(Problem.A, 25000, 25000, 1, 1);
	size(M)
	nnz(M)
end
