function [f] = mixNmatchMF_loss_L2(M, U, V)
  f  = 0 + mean(mean((M-U*V).^2));
end
