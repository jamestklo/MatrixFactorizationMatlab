function [points] = mixNmatchMF_batchAt_random(M, options, t)
  totalSize = nnz(M);
  if isfield(options, 'batchSize')
    batchSize = options.batchSize;
  else 
  	batchSize = 1;
  	options.batchSize = 1;
  end

  points = find(M);
  if batchSize < totalSize    
    % randomly select batchSize points from non-zero entries
	% sample without replacement
	for b=1:batchSize
	  swap = ceil(totalSize*rand(1));
	  temp = points(b);
	  points(b) = points(swap);
	  points(swap) = temp;
	end
	points = points(1:batchSize);
  end
end
