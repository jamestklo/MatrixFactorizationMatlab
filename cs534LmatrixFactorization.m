function [] = cs534LmatrixFactorization()
  

end

function [U, V] = mf(M, U, V, options)
  maxIter	= options.maxIter;
  tolerance	= options.tolerance;
  errorDiff = options.errorDiff;
  objective = @options.objective;
  update	= @options.update;

  prev = -Inf;
  for t=1:maxIter
	[F, G_U, G_V, batchSize] = objective(M, U, V, options, t);
	[U] = update(U, G_U, options, t);
	[V] = update(V, G_V, options, t);
	
	% check for acceptance or convergence
	error = abs(sum(F));
	% acceptance: error is smaller than tolerance
	if (error < tolerance)
	  break;
	% convergence: error is not diminishing as quickly as we want
	else if (abs(error-prev) < errorDiff)
	  break;
	  % switch to another descent/ascent algorithm
	else
	  prev = loss;
	end
  endd
end

function [U] = updateSAG(U, G_U, options, t)
% stepSize < 0 for descent
% stepSize > 0 for ascent 
  stepSize = -0.0001; 
  SAG = options.SAG;
  points = find(G_U);
  for b=1:length(points)
    SAG(b) = G_U(b);
  end
  U = U + stepSize*( sum(SAG) )/N;
end

function [U] = updateStochastic(U, G_U, options, t)
% stepSize < 0 for descent
% stepSize > 0 for ascent
  stepSize = -0.0001;
  U = U + stepSize*G_U/batchSize;
end

function [objectiveSparseF] = objectiveSparseFactory(objectiveAt, regularizeAt, batchAt)
  function [F, G_U, G_V] = objectiveSparse(M, U, V, options)
    [nRows, nCols] = size(M);
    [nRows, nDims] = size(U);
    F = sparse(nRows, nCols);
    G_U = sparse(nRows, nDims);
	G_V = sparse(nDims, nRows);

	lambda = options.lambda;

    [points] = batchAt(M, t);
	batchSize = length(points);
	G_Ub = zeros(batchSize, nDim);
	G_Vb = zeros(nDim, batchSize);		
	
    %for i=1:nRows
      %for j=1:nCols
	for b=1:batchSize;
        [i, j] = position(points(b), nRows);
	  
		[o_f, o_gu, o_gv] = objectiveAt(M, U, V, i, j);
		[r_f, r_gu, r_gv] = regularizeAt(lambda, U, V, i, j);
	    F(i,j)	= (o_f  + r_f);
		G_Ub(b,:)	= (o_gu + r_gu); % 1 x nDim
		G_Vb(:,b)	= (o_gv + r_gv); % nDim x 1
    end
	for b=1:batchSize
	  [i, j] = position(points(b), nRows);
	  G_U(i,:) = G_U(i,:) + G_Ub(b);
	  G_V(:,j) = G_V(:,j) + G_Vb(b);
	end
  end
  objectiveSparseF = @objectiveSparse;
end

function [i, j] = position(point, nRows)
  j = ceil(point/nRows);
  i = point - nRows*(j-1);
end

function [points] = batchAt(M, t)
  batchSize = 10;
  totalSize = nnz(M);
  if batchSize > totalSize
    points = find(M);
  else
    all = find(M);
    % randomly select batchSize points from non-zero entries
	% sample without replacement
	for b=1:batchSize
	  swap = ceil(batchSize*rand(1));
	  temp = all(b);
	  all(b) = all(swap);
	  all(swap) = temp;
	end
	for b=1:batchSize
	  points = all(1:b);
	end
  end
end

function [f] = lossL2(M, U, V)
  f  = mean(mean((M-U*V).^2));
end

function [f, gu, gv] = lossL2at(M, U, V, i, j)
  Ui = U(i,:); % 1 x nDim
  Vj = V(:,j); % nDim x 1
  f = (M(i,j) - Ui*Vj);
  gu = -(Vj')*2*f; % 1 x nDim
  gv = -(Ui')*2*f; % Dim x 1
  f = f^2;
end 

function [f, gu, gv] = regularizeL2at(lambda, U, V, i, j)
  Ui = U(i,:); % 1 x nDim
  Vj = V(:,j); % nDim x 1
  f  = lambda* ( Ui*(Ui') + (Vj')*Vj );
  gu = lambda*2*Ui; % 1 x nDim
  gv = lambda*2*Vj; % nDim x 1
end

function [f] = regularizeL2(lambdaL2, U, V)
  f = lambdaL2* ( sum( (U')*U ) + sum( V*(V') ) );
end
