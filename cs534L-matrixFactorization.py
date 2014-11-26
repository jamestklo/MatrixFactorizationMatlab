try:
    import numpy
except:
    print "This implementation requires the numpy module."
    exit(0)

def lossL2(expected, guess):
  return pow(expected - guess, 2);

"""
def regularizeL2(lbda, U, V):
  return lbda*(np.sum(U*U) + np.sum(V*V));
"""
  
if __name__ == "__main__":
  M = [1,2,3,4]
  guess = [1,1,1,1];
  print '{0}'.format(lossL2(M, guess));
