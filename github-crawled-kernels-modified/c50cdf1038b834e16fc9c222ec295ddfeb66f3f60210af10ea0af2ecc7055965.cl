//{"A":0,"B":1,"scratch_1":2,"scratch_2":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan_add(global const int* A, global int* B, local int* scratch_1, local int* scratch_2) {
  int id = get_global_id(0);
  int lid = get_local_id(0);
  int N = get_local_size(0);
  local int* scratch_3;

  scratch_1[hook(2, lid)] = A[hook(0, id)];

  barrier(0x01);

  for (int i = 1; i < N; i *= 2) {
    if (lid >= i)
      scratch_2[hook(3, lid)] = scratch_1[hook(2, lid)] + scratch_1[hook(2, lid - i)];
    else
      scratch_2[hook(3, lid)] = scratch_1[hook(2, lid)];

    barrier(0x01);

    scratch_3 = scratch_2;
    scratch_2 = scratch_1;
    scratch_1 = scratch_3;
  }

  B[hook(1, id)] = scratch_1[hook(2, lid)];
}