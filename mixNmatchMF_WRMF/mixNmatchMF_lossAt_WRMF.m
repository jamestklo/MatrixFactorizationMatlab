function [f, gu, gv] = mixNmatchMF_lossAt_WRMF(M, U, V, i, j)
	Ui = U(i,:); % 1 x nDim
  Vj = V(:,j); % nDim x 1
  Mij = M(i,j);
	f = Ui*Vj - 1;
  gu = Mij*(Vj')*2*f; % 1 x nDim
  gv = Mij*(Ui')*2*f; % Dim x 1
  f = (f^2)*Mij;
end 
