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
	times = zeros(1, maxIter);
	memry = zeros(1, maxIter);
	for t=1:maxIter
		tic;	% start timer
		[points] = options.batchAt(M, options, t);
		[f, G_Ub, G_Vb] = objective(M, U, V, points, options, t);
		[U, V, options, t] = update(M, U, V, f, G_Ub, G_Vb, points, options, t);
		times(t) = toc;
		if false
			temp = memory; % read memory usage
			memry(t) = ceil( (temp.MemUsedMATLAB)/1000000 );
		end
		f_avg = mean(f);
		if ( (stepSize > 0 && f_avg > f_opt) || (stepSize < 0 && f_avg < f_opt) )
			f_opt = f_avg;
			t_opt = t;
			Uopt = U;
			Vopt = V;
			fprintf('mixNmatchMF(): t=%d\tf_opt=%1.16d\ttime=%1.16d\tmemry=%1.6d\n', t_opt, f_opt, times(t_opt), memry(t_opt));
		end
	end
	f_all = objectiveAll(M, Uopt, Vopt);
	%times_tot = sum(times(1:t_opt));
	times_avg = mean(times);
	times_999 = prctile(times, 99.9);
	memry_avg = mean(memry);
	memry_999 = prctile(memry, 99.9);
	fprintf('mixNmatchMF(): t=%d\tf_opt=%1.16d\tf_all=%1.16d\ttimes_avg=%1.16d\ttimes_999=%5d\tmemry_avg=%1.6d\tmemry_999=%1.6d\n', t_opt, f_opt, f_all, times_avg, times_999, memry_avg, memry_999);
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
