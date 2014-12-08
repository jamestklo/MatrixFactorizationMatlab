function [f, gu, gv] = mixNmatchMF_objectiveAt_BPR(M, U, V, i, j)
% Y	nRows x nCols matrix
% U nRows x nDims matrix
% V	nDims x nCols matrix 
	Ui = U(i,:);	
	difV2 = V(:,j) - mean(V,2);
	f  = Ui*difV2;
	gu = difV2';	% 1 x nDims
	gv = Ui'; 		% nDims x 1
end
