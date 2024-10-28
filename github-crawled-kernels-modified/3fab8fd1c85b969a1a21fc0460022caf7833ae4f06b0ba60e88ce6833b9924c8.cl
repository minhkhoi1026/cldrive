//{"A":0,"B":1,"field":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void CalcPrefixSum(local int* field) {
  for (int d = 0; d < 8; d++) {
    int i = (1 << (d + 1)) - 1 + get_local_id(0) * (1 << (d + 1));

    if (i < 256) {
      field[hook(2, i)] += field[hook(2, i - (1 << d))];
    }
    barrier(0x01);
  }

  if (get_local_id(0) == 0)
    field[hook(2, 256 - 1)] = 0;

  barrier(0x01);

  for (int d = 8 - 1; d >= 0; d--) {
    int i = (1 << (d + 1)) - 1 + get_local_id(0) * (1 << (d + 1));

    if (i < 256) {
      int temp = field[hook(2, i)];
      field[hook(2, i)] += field[hook(2, i - (1 << d))];
      field[hook(2, i - (1 << d))] = temp;
    }
    barrier(0x01);
  }
}

kernel void PrefixSum(global const int* A, global int* B) {
  local int field[256];
  field[hook(2, get_global_id(0))] = A[hook(0, get_global_id(0))];
  barrier(0x01);

  CalcPrefixSum(field);

  B[hook(1, get_global_id(0))] = field[hook(2, get_global_id(0))];
}