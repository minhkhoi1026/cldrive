//{"byteNr":5,"dest":1,"field":6,"prefix":2,"size":3,"source":0,"tempSize":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void CalcPrefixSum(local int* field) {
  for (int d = 0; d < 8; d++) {
    int i = (1 << (d + 1)) - 1 + get_local_id(0) * (1 << (d + 1));

    if (i < 256) {
      field[hook(6, i)] += field[hook(6, i - (1 << d))];
    }
    barrier(0x01);
  }

  if (get_local_id(0) == 0)
    field[hook(6, 256 - 1)] = 0;

  barrier(0x01);

  for (int d = 8 - 1; d >= 0; d--) {
    int i = (1 << (d + 1)) - 1 + get_local_id(0) * (1 << (d + 1));

    if (i < 256) {
      int temp = field[hook(6, i)];
      field[hook(6, i)] += field[hook(6, i - (1 << d))];
      field[hook(6, i - (1 << d))] = temp;
    }
    barrier(0x01);
  }
}

kernel void Insert(global const int* source, global int* dest, global const int* prefix, const int size, const int tempSize, const int byteNr) {
  local int field[256];
  field[hook(6, get_global_id(0))] = prefix[hook(2, get_global_id(0))];
  barrier(0x01);

  int shift = 8 * byteNr;

  for (int i = 0; i < tempSize; i++) {
    int index = get_global_id(0) + (i * 256);

    if (index < size) {
      uchar value = (source[hook(0, index)] >> shift) & 255;
      dest[hook(1, atomic_inc(&field[vhook(6, value)))] = source[hook(0, index)];
    }
    barrier(0x02);
  }
}