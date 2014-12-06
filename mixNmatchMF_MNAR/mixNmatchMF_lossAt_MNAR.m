function [f, gu, gv] = mixNmatchMF_lossAt_MNAR(M, U, V, i, j)
	Rij = 2;
	Wij = 0.05;
	Ui = U(i,:);
	Vj = V(:,j);
	f = M(i,j) - Rij - Ui*Vj;
	gu = -(Vj')*2*f*Wij;
	gv = -(Ui')*2*f*Wij;
	f = Wij * (f^2);
end
