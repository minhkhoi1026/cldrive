//{"field":3,"in":0,"offset":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void CalcPrefixSum(local int* field) {
  for (int d = 0; d < 8; d++) {
    int i = (1 << (d + 1)) - 1 + get_local_id(0) * (1 << (d + 1));

    if (i < 256) {
      field[hook(3, i)] += field[hook(3, i - (1 << d))];
    }
    barrier(0x01);
  }

  if (get_local_id(0) == 0)
    field[hook(3, 256 - 1)] = 0;

  barrier(0x01);

  for (int d = 8 - 1; d >= 0; d--) {
    int i = (1 << (d + 1)) - 1 + get_local_id(0) * (1 << (d + 1));

    if (i < 256) {
      int temp = field[hook(3, i)];
      field[hook(3, i)] += field[hook(3, i - (1 << d))];
      field[hook(3, i - (1 << d))] = temp;
    }
    barrier(0x01);
  }
}

kernel void Recursion(global const int* in, global int* out, const int offset) {
  local int value;
  value = 0;
  local int field[256];
  int index = get_local_id(0) + (offset * 256);
  barrier(0x01);

  field[hook(3, get_local_id(0))] = in[hook(0, index)];
  if (get_local_id(0) == 0 && offset > 0)
    value = out[hook(1, index - 1)] + in[hook(0, index - 1)];
  barrier(0x01);

  CalcPrefixSum(field);

  out[hook(1, index)] = field[hook(3, get_local_id(0))] + value;
}