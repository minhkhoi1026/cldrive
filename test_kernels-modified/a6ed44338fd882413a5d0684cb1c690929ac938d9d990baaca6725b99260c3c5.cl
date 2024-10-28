//{"A":0,"C":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SingleAddition(global const unsigned int* A, global unsigned int* C) {
  unsigned int a = A[hook(0, 0)];
  unsigned int c = 0;
  unsigned int i = 0;

  for (i = 0; i <= 640000000; i++) {
    c = a + c;
  }

  C[hook(1, 0)] = c;
}