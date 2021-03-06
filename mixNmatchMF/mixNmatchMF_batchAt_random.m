function [points] = mixNmatchMF_batchAt_random(M, options, t)
  totalSize = nnz(M);
  if isfield(options, 'batchSize')
    batchSize = options.batchSize;
    if (batchSize < 0) 
      if t == 1
        if isfield(options, 'SAG_nBufs') && options.SAG_nBufs < 0
          batchSize = -batchSize;
        else
          batchSize = totalSize;  
        end
      else
        batchSize = -batchSize;
      end
    end
  else 
    batchSize = 1;
    options.batchSize = 1;
  end

  points = find(M);
  if (batchSize ~= 0) && (batchSize < totalSize)
    % randomly select batchSize points from non-zero entries
    % sample without replacement
    maxSwaps = min(batchSize, totalSize);
    for b=1:maxSwaps
      swap = ceil(totalSize*rand(1));
      temp = points(b);
      points(b) = points(swap);
      points(swap) = temp;
    end
    points = points(1:batchSize);
  end
end
