//{"A":0,"N":2,"Npad":3,"k":4,"upper":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_k(global float* A, const int upper, unsigned int N, unsigned int Npad, unsigned int k) {
  int i = get_global_id(0);

  if (i > k && i < N) {
    float Akk = A[hook(0, k * Npad + k)];

    if (upper == 0) {
      A[hook(0, i * Npad + k)] = A[hook(0, i * Npad + k)] / Akk;

      A[hook(0, k * Npad + i)] = 0;

    } else if (upper == 1) {
      A[hook(0, k * Npad + i)] = A[hook(0, k * Npad + i)] / Akk;

      A[hook(0, i * Npad + k)] = 0;
    } else {
      return;
    }
  }
}