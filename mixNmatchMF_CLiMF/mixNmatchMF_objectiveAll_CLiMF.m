function [f] = mixNmatch_objective_CLiMF(Y, U, V)
	addpath '../mixNmatchMF/';
	[f] = mixNmatchMF_objectiveAll_sparse(Y, U, V, @mixNmatchMF_objectiveAt_CLiMF);
end
