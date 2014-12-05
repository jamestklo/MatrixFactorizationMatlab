function [] = mixNmatch_data_epinions()
	addpath '../mixNmatchMF/';
	addpath '../matrixMarket/';
	addpath '../mixNmatchMF_climf/';
	filepath = '../../climf/EP25_UPL5_train.mtx';
	[rows, cols, entries, rep, field, symm] = mminfo(filepath);
	[A, rows, cols, entries] = mmread(filepath);

	% climf
	
end
