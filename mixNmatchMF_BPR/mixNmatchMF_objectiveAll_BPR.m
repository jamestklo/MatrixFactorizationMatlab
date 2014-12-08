function [f] = mixNmatchMF_objectiveAll_BPR(M, U, V)
	addpath '../mixNmatchMF/';
	[f] = mixNmatchMF_objectiveAll_sparse(M, U, V, @mixNmatchMF_objectiveAt_BPR);
end
