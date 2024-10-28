//{"byteNr":3,"counts":5,"counts[g]":6,"counts[get_local_id(0)]":4,"field":0,"output":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void CalcPrefixSum(local int* field) {
  for (int d = 0; d < 8; d++) {
    int i = (1 << (d + 1)) - 1 + get_local_id(0) * (1 << (d + 1));

    if (i < 256) {
      field[hook(0, i)] += field[hook(0, i - (1 << d))];
    }
    barrier(0x01);
  }

  if (get_local_id(0) == 0)
    field[hook(0, 256 - 1)] = 0;

  barrier(0x01);

  for (int d = 8 - 1; d >= 0; d--) {
    int i = (1 << (d + 1)) - 1 + get_local_id(0) * (1 << (d + 1));

    if (i < 256) {
      int temp = field[hook(0, i)];
      field[hook(0, i)] += field[hook(0, i - (1 << d))];
      field[hook(0, i - (1 << d))] = temp;
    }
    barrier(0x01);
  }
}

kernel void Calc(global const int* field, global int* output, const int size, const int byteNr) {
  local int counts[32][256];
  for (int i = 0; i < 256; i++) {
    counts[hook(5, get_local_id(0))][hook(4, i)] = 0;
  }

  for (int g = 0; g < 32; g++) {
    for (int i = 0; i < 8; i++) {
      int index = (get_local_id(0) + i * 32) + (get_group_id(0) * 256);
      output[hook(1, index)] = 0;
    }
  }

  int shift = 8 * byteNr;
  int rangeMin = 8192 * get_group_id(0);
  int rangeMax = rangeMin + 8192;
  for (int i = get_local_id(0) + rangeMin; i < rangeMax; i += 32) {
    if (i < size) {
      uchar value = (field[hook(0, i)] >> shift) & 255;
      counts[hook(5, get_local_id(0))][hook(4, value)]++;
    }
  }

  barrier(0x01);

  for (int g = 0; g < 32; g++) {
    for (int i = 0; i < 8; i++) {
      int index = (get_local_id(0) + i * 32) + (get_group_id(0) * 256);
      output[hook(1, index)] += counts[hook(5, g)][hook(6, get_local_id(0) + i * 32)];
    }
  }
}