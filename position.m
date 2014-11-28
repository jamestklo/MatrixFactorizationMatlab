function [i, j] = position(point, nRows)
  j = ceil(point/nRows);
  i = point - nRows*(j-1);
end
