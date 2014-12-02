function [points] = mixNmatchMF_batchAt_10(M, options, t)
  totalSize = nnz(M);
  batchSize = 10;
  if batchSize > totalSize
    points = find(M);
  else
    all = find(M);
    % randomly select batchSize points from non-zero entries
	% sample without replacement
	for b=1:batchSize
	  swap = ceil(totalSize*rand(1));
	  temp = all(b);
	  all(b) = all(swap);
	  all(swap) = temp;
	end
	for b=1:batchSize
	  points = all(1:b);
	end
  end
end
