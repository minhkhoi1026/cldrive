//{"A":0,"B":1,"C":2,"numberOfElements":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vectorAdd(global const int* A, global const int* B, global int* C, const int numberOfElements) {
  unsigned int index = get_global_id(0);

  if (index >= numberOfElements)
    return;

  C[hook(2, index)] = A[hook(0, index)] + B[hook(1, index)];
}