function [stepSizeU, stepSizeV, t] = mixNmatchMF_lineSearch_lipschitz(M, U, V, f, G_Ub, G_Vb, points, options, t)
% line search to find step size by finding Lipschitz constant and setting stepsize to 1/L
% finds stepSizeU and stepSizeV independently	
	[isRegularizing, lambdaU, lambdaV] = mixNmatchMF_isRegularizing(options);
	precision = pow2(-26);
	[nRows, nDims] = size(U);

	% stepSizeU = 1/L_U; L_U = Lipschitz constant for U matrix
	stepSizeU = 1e8;
	% stepSizeV = 1/L_V; L_V = Lipschitz constant for V matrix	
	stepSizeV = 1e8;

	b = 1;
	point = points(b);
	[i, j] = position(point, nRows);

	f_b = f(b);

	% take min or max
	gU = G_Ub{b};	% 1 x nDims
	gUgU = gU*transpose(gU);
	gV = G_Vb{b};	% nDims x 1
	gVgV = transpose(gV)*gV;

	d = 0;
	if gUgU > precision
		o_f = Inf;
		Ui_orig = U(i,:);
		while (o_f  > (f_b - gUgU*stepSizeU))		
			U(i,:) = Ui_orig - gU*stepSizeU;
			fprintf('mixNmatchMF_lineSearch_lipschitz(): t=%d\tstepSizeU=%1.16d\to_f=%1.16d\trhs=%1.16d\n', t, stepSizeU, o_f, (f_b - gUgU*stepSizeU/2));
			[o_f, o_gu, o_gv] = options.objectiveAt(M, U, V, i, j);
			if isRegularizing
				[r_f, r_gu, r_gv] = options.regularizeAt(U, lambdaU, V, lambdaV, i, j);
				o_f = o_f + r_f;
			end
			%t = t + 1;
			stepSizeU = stepSizeU/2;
		end
		stepSizeU = stepSizeU*2;
		U(i,:) = Ui_orig;
	end
	if gVgV > precision
		o_f = Inf;
		Vj_orig = V(:,j);
		while (o_f  > (f_b - gVgV*stepSizeV)) 		
			V(:,j) = Vj_orig - gV*stepSizeV;
			fprintf('mixNmatchMF_lineSearch_lipschitz(): t=%d\tstepSizeV=%1.16d\to_f=%1.16d\trhs=%1.16d\n', t, stepSizeV, o_f, (f_b - gVgV*stepSizeV/2));
			[o_f, o_gu, o_gv] = options.objectiveAt(M, U, V, i, j);
			if isRegularizing
				[r_f, r_gu, r_gv] = options.regularizeAt(U, lambdaU, V, lambdaV, i, j);
				o_f = o_f + r_f;
			end
			%t = t + 1;
			stepSizeV = stepSizeV/2;
		end
		stepSizeV = stepSizeV*2;
		V(:,j) = Vj_orig;
	end	
end
