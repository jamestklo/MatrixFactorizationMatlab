function [f, gu, gv] = mixNmatchMF_regularizeL2At(U, lambdaU, V, lambdaV, i, j)
  Ui = U(i,:); % 1 x nDim
  Vj = V(:,j); % nDim x 1
  f  = lambdaU*Ui*(Ui') + lambdaV*(Vj')*Vj;
  gu = lambdaU*2*Ui; % 1 x nDim
  gv = lambdaV*2*Vj; % nDim x 1
end

%function [f] = regularizeL2(lambdaL2, U, V)
  %f = lambdaL2* ( sum( (U')*U ) + sum( V*(V') ) );
%end
