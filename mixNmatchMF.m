function [U, V] = mixNmatchMF(M, U, V, options)
  maxIter	= options.maxIter;
  tolerance	= options.tolerance;
  difference = options.difference;
  objective = @options.objective;
  update	= @options.update;

  prev_f = -Inf;
  for t=1:maxIter
	[f, G_Ub, G_Vb, points] = objective(M, U, V, options, t);
	[U, V] = update(U, G_Ub, V, G_Vb, points, options, t);
	
	% check for acceptance or convergence
	% acceptance: error is smaller than tolerance
	if f < tolerance
	  break;
	% convergence: error is not diminishing as quickly as we want
	else if abs(f-prev_f) < diff
	  break;
	  % switch to another descent/ascent algorithm
	else
	  prev_f = loss;
	end
  end
end

function [U, V] = updateMemory(U, G_Ub, V, G_Vb, points, options, t)
% U		a nRows x nDims matrix 
% V		a nDims x nCols matrix
% G_Ub	a cell of b 1 x nDims arrays
% G_Vb	a cell of b nDims x 1 arrays
% points array of points processed in the current batch
% options.G_Umemory		nRows x nDims sparse matrix
% options.G_Vmemory		nDims x nCols sparse matrix
% options.SAG_Umemory   nRows*nCols x nDims sparse matrix
% options.SAG_Vmemory   nCols*nRows x nDims sparse matrix
  batchSize = length(points);
  if batchSize > 0
    [nRows, nDims] = size(U);
	[nDims, nCols] = size(V);
	for b=1:batchSize
	  point = points(b);
	  [i, j] = position(point, nRows);
	  % take the old one away, put the new one in
	  options.G_Umemory(i,:) = options.G_Umemory(i,:) - options.SAG_Umemory(point,:) + G_Ub{b}; % 1 x nDims
	  options.G_Vmemory(:,j) = options.G_Vmemory(:,j) - options.SAG_Vmemory(:,point) + G_Vb{b}; % nDims x 1
	  options.SAG_Umemory(point,:) = G_Ub{b}; % 1 x nDims
	  options.SAG_Vmemory(:,point) = G_Vb{b}; % nDims x 1
	end
    % stepSize < 0 for descent
    % stepSize > 0 for ascent
    stepSize = -0.0001;
	stepSize = stepSize/t;
    U = U + stepSize*(options.G_Umemory);
    V = V + stepSize*(options.G_Vmemory);	
  end  
end
