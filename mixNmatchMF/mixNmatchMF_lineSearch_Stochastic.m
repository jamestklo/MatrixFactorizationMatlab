function [L_U, L_V, t] = mixNmatchMF_update_LineSearch(M, U, V, f, G_Ub, G_Vb, points, options, t)
	[isRegularizing, lambdaU, lambdaV] = mixNmatchMF_isRegularizing(options);
	precision = pow2(-26);

	L_U = 1e-8;
	L_V = 1e-8;

	b = 1;
	f_b = f(b);
	gU = G_Ub{b};	% 1 x nDims
	gUgU = gU*transpose(gU);
	gV = G_Vb{b};	% nDims x 1
	gVgV = transpose(gV)*gV;

	if gUgU > precision
		o_f = Inf;
		Ui_orig = U(i,:);
		while ( o_f > (f_b - gUgU/(2*L_U)) ) % && ( o_f > (f_b - gUgU/(2*L_U)) )
			U(i,:) = Ui_orig - gU/L_U; % 1 x nDims
			%V(:,j) = Vj_orig - gV/L_V; % nDims x 1
			[o_f, o_gu, o_gv] = options.objectiveAt(M, U, V, i, j);
			if isRegularizing
				[r_f, r_gu, r_gv] = options.regularizeAt(U, lambdaU, V, lambdaV, i, j);
				o_f = o_f + r_f;
			end
			t = t + 1;
			L_U = 2*L_U;
			%L_V = 2*L_V;
		end
		U(i,:) = Ui_orig;
	end

	if gVgV > precision
		o_f = Inf;
		Vj_orig = V(:,j);
		while ( o_f > (f_b - gVgV/(2*L_V)) )
			V(:,j) = Vj_orig - gV/L_V; % nDims x 1
			[o_f, o_gu, o_gv] = options.objectiveAt(M, U, V, i, j);
			if isRegularizing
				[r_f, r_gu, r_gv] = options.regularizeAt(U, lambdaU, V, lambdaV, i, j);
				o_f = o_f + r_f;
			end
			t = t + 1;
			L_V = 2*L_V;
		end
		V(:,j) = Vj_orig;
	end
end
