% has to know API header, what each input argument is
function [f, gu, gv] = mixNmatchMF_objectiveAt_CLiMF(Y, U, V, i, j)
% Y	nRows x nCols matrix
% U nRows x nDims matrix
% V	nDims x nCols matrix
	[nRows, nCols] = size(Y);
	[nRows, nDims] = size(U);
 
	Yij = Y(i,j);
	if Yij == 0
		f  = 0;
		gu = zeros(1, nDims);
		gv = zeros(nDims, 1);	 
	else 
		Ui = U(i,:);	
		Vj = V(:,j);
		Vj_transposed = Vj';
		UiVj = Ui*Vj;

		f_k  = zeros(nCols, 1);
		gu_k = zeros(nCols, nDims);
		gv_k = zeros(nCols, 1);
		nCols = length(Vj);
		parfor k=1:nCols
			Yik = Y(i,k);
			if Yik ~= 0 && k ~= j
				UiVk = Ui*V(:,k);
				denominator = 1 - Yik*logistic(UiVk - UiVj);

				f_k(k) = log(denominator);

				gu_k(k, :) = (Vj_transposed - (V(:,k))') * Yik * logistic_d1(UiVk - UiVj) / denominator;

				denominator = 1/denominator - 1/( 1 - Yij * logistic(UiVj - UiVk) );
				gv_k(k) = Yik * logistic_d1(UiVj - UiVk) * denominator;
			end
		end			

		gv = logistic(-UiVj);
		gu = Vj_transposed*gv;

		f  = Yij * (log( logistic(UiVj) ) + sum(f_k));
		gu = Yij * (gu + sum(gu_k));
		gv = Yij * (gv + sum(gv_k)) * (Ui');
	end
end


% logistic function 
function [f] = logistic(x)
	f = 1/( 1 + exp(-x) );
end


function [g] = logistic_d1(x)
	exp_x = exp(-x);
	g = exp_x/( (1 + exp_x)^2 );
end
