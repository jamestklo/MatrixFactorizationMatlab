function [] = mixNmatch_climf()

end

function [f, G_Ub, G_Vb, points] = mixNmatchMF_objectiveSparse2(M, U, V, options, t)
  objectiveAt = options.objectiveAt;
  gradientAt = options.gradientAt;
  regularizeAt = options.regularizeAt;
  batchAt = options.batchAt;
  lambda = options.lambda;
  [nRows, nCols] = size(M);
  totalSize = nnz(M);

  if (nRows*nCols/totalSize) > 2
    F = sparse(nRows, nCols);
  else
    F = zeros(nRows, nCols);       
  end

  [points] = batchAt(M, options, t);
  batchSize = length(points);
  G_Ub = cell(batchSize,1);
  G_Vb = cell(batchSize,1);

  for b=1:batchSize
    [i, j] = position(points(b), nRows);
    [o_f] = objectiveAt(M, U, V, i, j);
    [r_f, G_Ub{b}, G_Vb{b}] = regularizeAt(lambda, U, V, i, j);
    F(i,j) = (o_f + r_f);
  end
  
  for b=1:batchSize
    [i, j] = position(points(b), nRows);    
    [o_gu, o_gv] = gradientAt(Y, U, V, i, j, F);
    G_Ub{b} = G_Ub{b} + o_gu; 
    G_Vb{b} = G_Vb{b} + o_gv;
  end
  f = sum(sum(abs(F)))/batchSize;
end

% has to know API header, what each input argument is
function [f] = mixNmatch_objective_climfAt(Y, U, V, i, j)
% Y	nRows x nCols matrix
% U nRows x nDims matrix
% V	nDims x nCols matrix
  Ui = U(i,:);  
  Vj = V(:,j);
  UiVj = Ui*Vj;
  nCols = length(Vj);
  
  f = log( logistic(UiVj) ); % 1 x 1 
  for k=1:nCols
    f = f + log( 1 - Y(i,k)*logistic(Ui*V(:,k) - UiVj) );    
  end  
  f = Y(i,j)*f;
end

function [gu, gv] = mixNmatch_gradient_climfAt(Y, U, V, i, j, F)
  Ui = U(i,:); % 1 x nDims row
  Vj = V(:,j);      % nDims x 1 col
  Vj_transposed = Vj';
  Yij = Y(i,j);
  Fij = F(i,j);
  gv = g(-Fij);
  gu = (Vj')*gv; % 1 x nDims row  
  for k=1:nCols      
    Yik = Y(i,k);
    Fik = F(i,k);    
    
    denominator =  1 - Yik * logistic(Fik - Fij);
    gu = gu + (Vj_transposed - (V(:,k))') * Yik * logistic_d1(Fik - Fij) / denominator;    
    
    denominator = 1/denominator - 1/( 1 - Yij * logistic(Fij - Fik) );
    gv = gv + Yik * logistic_d1(Fij - Fik) * denominator;
  end    
  gu = Yij * gu;
  gv = Yij * gv * (Ui');  
end


% logistic function 
function [f] = logistic(x)
  f = 1/( 1 + exp(-x) );
end
function [g] = logistic_d1(x)
  exp_x = exp(-x);
  g = exp_x/( (1 + exp_x)^2 );
end
