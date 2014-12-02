function [f, gu, gv] = lossL2at(M, U, V, i, j)
  Ui = U(i,:); % 1 x nDim
  Vj = V(:,j); % nDim x 1
  f = (M(i,j) - Ui*Vj);
  gu = -(Vj')*2*f; % 1 x nDim
  gv = -(Ui')*2*f; % Dim x 1
  f = f^2;
end 

%function [f] = lossL2(M, U, V)
%  f  = mean(mean((M-U*V).^2));
%end
