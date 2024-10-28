//{"A":0,"N":2,"Npad":3,"k":4,"upper":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_block(global double* A, const int upper, unsigned int N, unsigned int Npad, unsigned int k) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  if (i <= k || j <= k)
    return;
  if (i >= N || j > i)
    return;

  if (upper == 0) {
    double Aik = A[hook(0, i * Npad + k)];
    double Ajk = A[hook(0, j * Npad + k)];
    double Aij = A[hook(0, i * Npad + j)];

    A[hook(0, i * Npad + j)] = Aij - Aik * Ajk;

  } else if (upper == 1) {
    double Aik = A[hook(0, k * Npad + i)];
    double Ajk = A[hook(0, k * Npad + j)];
    double Aij = A[hook(0, j * Npad + i)];

    A[hook(0, j * Npad + i)] = Aij - Aik * Ajk;
  } else {
    return;
  }
}