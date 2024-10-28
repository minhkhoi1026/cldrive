//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_add_1(global const int* A, global int* B) {
  int id = get_global_id(0);
  int N = get_global_size(0);

  B[hook(1, id)] = A[hook(0, id)];

  barrier(0x02);

  if (((id % 2) == 0) && ((id + 1) < N))
    B[hook(1, id)] += B[hook(1, id + 1)];

  barrier(0x02);

  if (((id % 4) == 0) && ((id + 2) < N))
    B[hook(1, id)] += B[hook(1, id + 2)];

  barrier(0x02);

  if (((id % 8) == 0) && ((id + 4) < N))
    B[hook(1, id)] += B[hook(1, id + 4)];

  barrier(0x02);

  if (((id % 16) == 0) && ((id + 8) < N))
    B[hook(1, id)] += B[hook(1, id + 8)];
}