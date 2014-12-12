function [subA] = mixNmatchMF_data_ProblemA(inputpath, outputpath)
	load(inputpath);
	subA = Problem.A;
	save(outputpath, 'subA');
end

%mixNmatchMF_data_ProblemA('../mixNmatchMF_data_mat/digg12month1.mat', './digg12month1.mat');
%mixNmatchMF_data_ProblemA('../mixNmatchMF_data_mat/IMDB.mat', './IMDB.mat');
%mixNmatchMF_data_ProblemA('../mixNmatchMF_data_mat/ljournal-2008.mat', './ljournal-2008.mat');
%mixNmatchMF_data_ProblemA('../mixNmatchMF_data_mat/wikipedia-20070206.mat', './wikipedia-20070206.mat');