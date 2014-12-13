function [table] = mixNmatchMF_experiment_save(filepath, results, labels)
	% check if table exists	
	if exist(filepath, 'file') > 0
		load(filepath);	
	else
		table = cell(length(labels), 1+3*6);
	end
	
	% else create new table, set up rows
	tRows = length(labels);
	for i=1:tRows
		row = results{i};
		tCols = length(row);
		if tCols > 0
			for j=1:tCols
				col = row{j};
				tMets = length(col);
				if tMets > 0
					table{i,1} = labels{i};
					for k=1:tMets
						table{i, 1+(k-1)*tCols+j} = col(k);
					end
				end
			end
		end
	end

	% add f_all
  %table{rowAt, 1+0*tCols+colAt} = f_all;

  % add t_opt
  %table{rowAt, 1+1*tCols+colAt} = t_opt;

  % add times_avg
  %table{rowAt, 1+2*tCols+colAt} = times_avg;

  % add times_999
  %table{rowAt, 1+3*tCols+colAt} = times_999;

  % add memry_avg
  %table{rowAt, 1+4*tCols+colAt} = memry_avg;

  % add memry_999
  %table{rowAt, 1+5*tCols+colAt} = memry_999;
 
  % write data to file
  save(filepath, 'table');
end
