function [] = mixNmatchMF_data_epinions()
	mixNmatchMF_data_epinions2();
end

function [] = mixNmatchMF_data_epinions2()
	addpath '../mixNmatchMF/';
	addpath '../matrixMarket/';
	addpath '../mixNmatchMF_L2/';

	[M, nRows, nCols, entries] = mmread('../../climf/EP25_UPL5_test.mtx');
	nDims = 5;
	U = rand(nRows, nDims);
	V = rand(nDims, nCols);
  fprintf('nnz=%d\tnRows=%d\tnCols%d\n', nnz(M), nRows, nCols);
	tic;
	%f = mixNmatchMF_loss_L2(M, U, V)
	toc;
end

function [M, nRows, nCols] = mixNmatchMF_data_epinionsT()
	addpath '../matrixMarket/';
	[M, nRows, nCols] = mmread('../../climf/EP25_UPL5_train.mtx');
end

function [M, nRows, nCols] = mixNmatchMF_data_epinionsS()
	addpath '../matrixMarket/';
	[M, nRows, nCols] = mmread('../../climf/EP25_UPL5_test.mtx');
end

function [options] = mixNmatchMF_epinions_L2(options) 
	addpath '../mixNmatchMF_L2/';
	options.objectiveAll = @mixNmatchMF_loss_L2;
	options.objectiveAt = @mixNmatchMF_lossAt_L2;
	% stochastic gradient descent
	options.stepSize = -0.01;
end

function [options] = mixNmatchMF_epinions_WRMF(options) 
	addpath '../mixNmatchMF_WRMF/';
	options.objectiveAll = @mixNmatchMF_loss_WRMF;
	options.objectiveAt = @mixNmatchMF_lossAt_WRMF;
	% stochastic gradient descent
	options.stepSize = -0.01;
end

function [options] = mixNmatchMF_epinions_MMMF(options) 
	addpath '../mixNmatchMF_MMMF/';
	options.objectiveAll = @mixNmatchMF_loss_MMMF;
	options.objectiveAt = @mixNmatchMF_lossAt_MMMF;
	% stochastic gradient descent
	options.stepSize = -0.01;
end
