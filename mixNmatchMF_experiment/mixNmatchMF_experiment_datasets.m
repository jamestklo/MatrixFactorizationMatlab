function [data, table] = mixNmatchMF_experiment_datasets(optionsF, filepath, options)
	data = cell(5,1);
	addpath '../mixNmatchMF_data/';

	if false
		d = 1;
		data{d} = cell(4,1);
		data{d}{1} = 'epinions'; 
		data{d}{2} = options;	
		data{d}{3} = optionsF;
		data{d}{4} = @mixNmatchMF_data_epinionsTrain; 
	end

	if true
		d = 2;
		data{d} = cell(4,1);
		data{d}{1} = 'Digg'; 
		data{d}{2} = options;	
		data{d}{3} = optionsF; 
		data{d}{4} = @mixNmatchMF_data_digg;	
	end

	if false
		d = 3;
		data{d} = cell(4,1);
		data{d}{1} = 'IMDB'; 
		data{d}{2} = options;	
		data{d}{3} = optionsF; 
		data{d}{4} = @mixNmatchMF_data_IMDB;	
	end

	if false
		d = 4;
		data{d} = cell(4,1);
		data{d}{1} = 'LiveJournal'; 
		data{d}{2} = options;	
		data{d}{3} = optionsF; 
		data{d}{4} = @mixNmatchMF_data_LiveJournal;	
	end

	if false
		d = 5;
		data{d} = cell(4,1);
		data{d}{1} = 'Wikipedia'; 
		data{d}{2} = options;	
		data{d}{3} = optionsF; 
		data{d}{4} = @mixNmatchMF_data_Wikipedia;	
	end

	% start experiment
	addpath '../mixNmatchMF_experiment/';
	[results, labels] = mixNmatchMF_experiment_start(data);

	% save results
	[table] = mixNmatchMF_experiment_save(filepath, results, labels);
end
