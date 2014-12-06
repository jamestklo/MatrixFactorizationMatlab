function [Uopt, Vopt, f_opt, f_all, t_opt, times_avg, times_999, memry_avg, memry_999] = mixNmatchMF(M, U, V, options)
	options = mixNmatchMF_default(options);

	tolerance = options.tolerance;
	difference = options.difference;

	objective = @options.objective;
	objectiveAll = @options.objectiveAll;
	update	= @options.update;
	
	stepSize = options.stepSize;

	f_opt = (0-stepSize)*Inf;
	f_all = f_opt;
	t_opt = 0;
	Uopt = U;
	Vopt = V;

	f_prev = -Inf;

	maxIter = options.maxIter;
	times = zeros(maxIter, 1);
	for t=1:maxIter
		pack; % consolidate memory
		tic;	% start timer
		[f, G_Ub, G_Vb, points] = objective(M, U, V, options, t);
		[U, V] = update(M, U, G_Ub, V, G_Vb, points, options, t);
		times(t) = toc;	
		memry(t) = memory; % read memory usage
		memry(t) = ceil( (memry(t).MemUsedMATLAB)/1000000 );

		if ( (stepSize > 0 && f > f_opt) || (stepSize < 0 && f < f_opt) )
			f_opt = f;
			t_opt = t;
			Uopt = U;
			Vopt = V;
		end
		
		% check for acceptance or convergence
		% acceptance: error is smaller than tolerance
		%if f < tolerance
			%break;
			% convergence: error is not diminishing as quickly as we want
		%elseif abs(f - f_prev) < difference
			%break;
			% switch to another descent/ascent algorithm
		%else
			%f_prev = f;
		%end
	end
	f_all = objectiveAll(M, Uopt, Vopt);
	%times_tot = sum(times(1:t_opt));
	times_avg = mean(times);
	times_999 = prctile(times, 99.9);
	memry_avg = means(memry);
	memry_999 = prctile(memry, 99.9);
	fprintf('mixNmatchMF(): t=%d\tf_opt=%1.16d\tf_all=%1.16d\ttime=%1.16d\n', t_opt, f_opt, f_all, times{t_opt});
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
