function [v] = prctile(array, at)
	sorted = sort(array, 'descend');
	v = sorted[1+floor((1-at/100)*length(array))];
end
