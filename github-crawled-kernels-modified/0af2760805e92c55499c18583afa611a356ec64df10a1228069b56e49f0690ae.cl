//{"N":3,"c_Table":1,"d_Output":0,"seed":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void QuasirandomGenerator(global float* d_Output, constant unsigned int* c_Table, unsigned int seed, unsigned int N) {
  unsigned int globalID_x = get_global_id(0);
  unsigned int localID_y = get_local_id(1);
  unsigned int globalSize_x = get_global_size(0);

  for (unsigned int pos = globalID_x; pos < N; pos += globalSize_x) {
    unsigned int result = 0;
    unsigned int data = seed + pos;

    for (int bit = 0; bit < 31; bit++, data >>= 1)
      if (data & 1)
        result ^= c_Table[hook(1, bit + localID_y * 31)];

    d_Output[hook(0, mul24(localID_y, N) + pos)] = (float)(result + 1) * (1.0f / (float)0x80000001U);
  }
}