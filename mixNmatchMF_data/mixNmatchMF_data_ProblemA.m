function [subA] = mixNmatchMF_data_ProblemA(inputpath, outputpath)
	load(inputpath);
	subA = Problem.A;
	save(outputpath, 'subA');
end
