function [f] = mixNmatchMF_loss_WRMF(M, U, V)
	f = 0 + mean( mean( M.*( ((U*V)-1).^2 ) ) );
end
