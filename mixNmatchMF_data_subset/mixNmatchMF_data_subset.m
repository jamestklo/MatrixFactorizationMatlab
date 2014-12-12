function [Msub] = mixNmatchMF_data_subset(M, subsetSize)
	[nRows, nCols] = size(M);
	Msub = sparse(nRows, nCols);
	points = find(M);
	totalSize = nnz(M);
  if (subsetSize ~= 0) && (subsetSize < totalSize)
		% randomly select subset points from non-zero entries
		% sample without replacement
		maxSwaps = min(subsetSize, round(totalSize/2));
		for b=1:maxSwaps
			swap = ceil(totalSize*rand(1));
			temp = points(b);
			points(b) = points(swap);
			points(swap) = temp;
		end
		points = points(1:batchSize);	
	end
	for b=1:length(points)
		Msub(points(b)) = M((points(b));
	end
end
