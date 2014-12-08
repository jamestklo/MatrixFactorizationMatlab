function [v] = prctile(array, at)
	sorted = sort(array, 'descend');
	len = length(sorted);
	v = sorted[1+floor((1-at/100)*len)];
end
