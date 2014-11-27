try:
	import numpy
except:
    print "This implementation requires the numpy module."
    exit(0)

def matrix_factorization(M, U, V, maxIter, lossF, condF)
  e = 0;
  for t in xrange(maxIter):
    for i in xrange(len(M)):
	  for j in xrange(len(M[i])):
	    Mij = M[i][j];
	    """ 
	    if (condF(mij)
	    """
	    if (Mij > 0): 
	      e = e + lossF(Mij, numpy.dot(U[i,:],V[:,j]));
		  for k in xrange(len(V)):
		    e = e + 
		    
	    
def lossL2(expected, guess):
  return pow(expected - guess, 2);


def regularizeL2(lbda, U, V, i, j):
  reguloss = 0;
  for k in xrange(len(V)):
    reguloss = reguloss + ( pow(U[i][k],2) + pow(V[k][j],2) );	

  return lbda * ;

  
if __name__ == "__main__":
  M = [1,2,3,4]
  guess = [1,1,1,1];
  print '{0}'.format(lossL2(M, guess));
  