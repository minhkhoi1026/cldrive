//{"d_Data":1,"d_Result":0,"dataCount":4,"maximum":3,"minimum":2,"s_Hist":6,"s_WarpHist":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void addData1024(volatile local unsigned int* s_WarpHist, unsigned int data, unsigned int tag) {
  unsigned int count;
  do {
    count = s_WarpHist[hook(5, data)] & 0x07FFFFFFU;
    count = tag | (count + 1);
    s_WarpHist[hook(5, data)] = count;
  } while (s_WarpHist[hook(5, data)] != count);
}

kernel void histogram1024Kernel(global unsigned int* d_Result, global float* d_Data, float minimum, float maximum, unsigned int dataCount) {
  const int gid = get_global_id(0);
  const int gsize = get_global_size(0);

  int mulBase = (get_local_id(0) >> 5);
  const int warpBase = mul24(mulBase, (1024));
  local unsigned int s_Hist[(3 * (1024))];
  int test = 0;

  const unsigned int tag = get_local_id(0) << (32 - 5);

  for (unsigned int i = get_local_id(0); i < (3 * (1024)); i += get_local_size(0)) {
    s_Hist[hook(6, i)] = 0;
  }

  barrier(0x01 | 0x02);
  for (int pos = get_global_id(0); pos < dataCount; pos += get_global_size(0)) {
    unsigned int data4 = ((d_Data[hook(1, pos)] - minimum) / (maximum - minimum)) * (1024);
    addData1024(s_Hist + warpBase, data4 & 0x3FFU, tag);
  }

  barrier(0x01 | 0x02);
  for (int pos = get_local_id(0); pos < (1024); pos += get_local_size(0)) {
    unsigned int sum = 0;
    for (int i = 0; i < (3 * (1024)); i += (1024)) {
      sum += s_Hist[hook(6, pos + i)] & 0x07FFFFFFU;
    }
    atomic_add(d_Result + pos, sum);
  }
}