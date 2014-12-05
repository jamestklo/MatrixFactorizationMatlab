function [U, V] = mixNmatchMF(M, U, V, options)
	maxIter	= options.maxIter;
	tolerance	= options.tolerance;
	difference = options.difference;
	objective = @options.objective;
	update	= @options.update;

	f_prev = -Inf;
  for t=1:maxIter
  	[f, G_Ub, G_Vb, points] = objective(M, U, V, options, t);
  	[U, V] = update(M, U, G_Ub, V, G_Vb, points, options, t);

    fprintf('mixNmatchMF(): t=%d\tf=%d\n', t, f);
  	% check for acceptance or convergence
  	% acceptance: error is smaller than tolerance
  	if f < tolerance
  		break;
  		% convergence: error is not diminishing as quickly as we want
    elseif abs(f - f_prev) < difference
    	break;
    	% switch to another descent/ascent algorithm
    else
    	f_prev = f;
    end
  end
end
