% has to know API header, what each input argument is
function [f, gu, gv] = mixNmatch_objectiveAt_CLiMF(Y, U, V, i, j)
% Y	nRows x nCols matrix
% U nRows x nDims matrix
% V	nDims x nCols matrix
	Ui = U(i,:);	
	Vj = V(:,j);
	Vj_transposed = Vj';
	UiVj = Ui*Vj;
	Yij = Y(i,j);
	if Yij == 0
		f  = 0;
		gu = zeros(1, nDims);
		gv = zeros(nDims, 1);	 
	else 
		f  = log( logistic(UiVj) ); % 1 x 1 
		gv = logistic(-UiVj);
		gu = Vj_transposed*gv;
	
		nCols = length(Vj);
		for k=1:nCols
			Yik = Y(i,k);
			if Yik ~= 0
				UiVk = Ui*V(:,k);
				denominator = 1 - Yik*logistic(UiVk - UiVj);
				f = f + log(denominator);

				gu = gu + (Vj_transposed - (V(:,k))') * Yik * logistic_d1(UiVk - UiVj) / denominator;

				denominator = 1/denominator - 1/( 1 - Yij * logistic(UiVj - UiVk) );
				gv = gv + Yik * logistic_d1(UiVj - UiVk) * denominator;
			end
		end	
		
		f  = Yij * f;
		gu = Yij * gu;
		gv = Yij * gv * (Ui');
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
