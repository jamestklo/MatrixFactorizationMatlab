function [f] = mixNmatchMF_lossAll_L2sparse(M, U, V)
	addpath '../mixNmatchMF/';
	[f] = mixNmatchMF_objectiveAll_sparse(M, U, V, @mixNmatchMF_lossAt_L2);
end
