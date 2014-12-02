function [f, gu, gv] = regularizeL2at(lambda, U, V, i, j)
  Ui = U(i,:); % 1 x nDim
  Vj = V(:,j); % nDim x 1
  f  = lambda* ( Ui*(Ui') + (Vj')*Vj );
  gu = lambda*2*Ui; % 1 x nDim
  gv = lambda*2*Vj; % nDim x 1
end

%function [f] = regularizeL2(lambdaL2, U, V)
  %f = lambdaL2* ( sum( (U')*U ) + sum( V*(V') ) );
%end
