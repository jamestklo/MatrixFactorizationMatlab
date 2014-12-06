function [f] = mixNmatchMF_loss_L2(M, U, V)
  f  = mean(mean((M-U*V).^2));
end
