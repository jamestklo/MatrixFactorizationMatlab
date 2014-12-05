function [Uopt, Vopt, f_opt, t_opt, times] = mixNmatchMF(M, U, V, options)
	options = mixNmatchMF_default(options);

  tolerance = options.tolerance;
  difference = options.difference;

	objective = @options.objective;
	update	= @options.update;
  
  stepSize = options.stepSize;

  f_opt = (0-stepSize)*Inf;
  t_opt = 0;
  Uopt = U;
  Vopt = V;

	f_prev = -Inf;

	times = cell(options.maxIter, 1);
	tic;
  for t=1:options.maxIter
  	[f, G_Ub, G_Vb, points] = objective(M, U, V, options, t);
  	[U, V] = update(M, U, G_Ub, V, G_Vb, points, options, t);
  	times{t} = toc;

    if ( (stepSize > 0 && f > f_opt) || (stepSize < 0 && f < f_opt) )
    	fprintf('mixNmatchMF(): t=%d\tf=%f\ttime=%f\n', t, f, times{t});
      f_opt = f;
      t_opt = t;
      Uopt = U;
      Vopt = V;
    end
		
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

function [options] = mixNmatchMF_default(options)
	if isfield(options, 'tolerance') == 0
		options.tolerance = 0;
	end
	if isfield(options, 'difference') == 0
		options.difference = 0;
	end
 	if isfield(options, 'stepSize') == 0
 		% stepSize < 0 for descent
 		% stepSize > 0 for ascent
  	options.StepSize = -0.0001;
  end
end
