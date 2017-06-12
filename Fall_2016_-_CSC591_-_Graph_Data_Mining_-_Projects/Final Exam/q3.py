# A is a n*n matrix
def power_mat(A, k):
	if k is even:
		a_square = A*A
		return pow(2,k/2) * a_square
	else:
		return pow(2,(k-1)/2) * A