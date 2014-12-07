function [] = mixNmatchMF_experiment_CLiMF()
	% create new table, set up rows
	tCols = 4;
	table = cell(2, 1+tCols*6);
	table{1, 1} = 'epinionsT';
	table{2, 1} = 'epinionsS';

	tablepath = './CLiMF';
	save(tablepath, 'table');
	clear table;
	close all;

	options = struct;
	options.maxIter = 10000;

	addpath '../mixNmatchMF_experiment/';

	addpath '../mixNmatchMF_data_epinions/';	
	mixNmatchMF_experiment_row(tablepath, 1, options, @mixNmatchMF_epinions_CLiMF, @mixNmatchMF_data_epinionsTrain);
	mixNmatchMF_experiment_row(tablepath, 2, options, @mixNmatchMF_epinions_CLiMF, @mixNmatchMF_data_epinionsTest);

	clear all;
	close all;
end
