//{"A":0,"B":1,"R":2,"ops":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void zipWith(global float* A, global float* B, global float* R, char ops) {
  int id = get_global_id(0);

  if (ops == '+')
    R[hook(2, id)] = A[hook(0, id)] + B[hook(1, id)];
  else if (ops == '-')
    R[hook(2, id)] = A[hook(0, id)] - B[hook(1, id)];
  else if (ops == '*')
    R[hook(2, id)] = A[hook(0, id)] * B[hook(1, id)];
  else if (ops == '/')
    R[hook(2, id)] = A[hook(0, id)] / B[hook(1, id)];
}