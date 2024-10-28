//{"data":6,"dataBase":1,"data_offset":2,"inter":7,"interBase":3,"inter_offset":4,"n":0,"s_data":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan_L1_kernel(unsigned int n, global unsigned int* dataBase, unsigned int data_offset, global unsigned int* interBase, unsigned int inter_offset) {
  local unsigned int s_data[(1024 + (1024 >> 4) + (1024 >> (2 * 4)))];

  global unsigned int* data = dataBase + data_offset;
  global unsigned int* inter = interBase + inter_offset;

  unsigned int thid = get_local_id(0);
  unsigned int g_ai = get_group_id(0) * 2 * get_local_size(0) + get_local_id(0);
  unsigned int g_bi = g_ai + get_local_size(0);

  unsigned int s_ai = thid;
  unsigned int s_bi = thid + get_local_size(0);

  s_ai += (((unsigned int)(s_ai) >> min((unsigned int)(4) + (s_ai), (unsigned int)(32 - (2 * 4)))) >> (2 * 4));
  s_bi += (((unsigned int)(s_bi) >> min((unsigned int)(4) + (s_bi), (unsigned int)(32 - (2 * 4)))) >> (2 * 4));

  s_data[hook(5, s_ai)] = (g_ai < n) ? data[hook(6, g_ai)] : 0;
  s_data[hook(5, s_bi)] = (g_bi < n) ? data[hook(6, g_bi)] : 0;

  unsigned int stride = 1;
  for (unsigned int d = get_local_size(0); d > 0; d >>= 1) {
    barrier(0x01);

    if (thid < d) {
      unsigned int i = 2 * stride * thid;
      unsigned int ai = i + stride - 1;
      unsigned int bi = ai + stride;

      ai += (((unsigned int)(ai) >> min((unsigned int)(4) + (ai), (unsigned int)(32 - (2 * 4)))) >> (2 * 4));
      bi += (((unsigned int)(bi) >> min((unsigned int)(4) + (bi), (unsigned int)(32 - (2 * 4)))) >> (2 * 4));

      s_data[hook(5, bi)] += s_data[hook(5, ai)];
    }

    stride *= 2;
  }

  if (thid == 0) {
    unsigned int last = get_local_size(0) * 2 - 1;
    last += (((unsigned int)(last) >> min((unsigned int)(4) + (last), (unsigned int)(32 - (2 * 4)))) >> (2 * 4));
    inter[hook(7, get_group_id(0))] = s_data[hook(5, last)];
    s_data[hook(5, last)] = 0;
  }

  for (unsigned int d = 1; d <= get_local_size(0); d *= 2) {
    stride >>= 1;

    barrier(0x01);

    if (thid < d) {
      unsigned int i = 2 * stride * thid;
      unsigned int ai = i + stride - 1;
      unsigned int bi = ai + stride;

      ai += (((unsigned int)(ai) >> min((unsigned int)(4) + (ai), (unsigned int)(32 - (2 * 4)))) >> (2 * 4));
      bi += (((unsigned int)(bi) >> min((unsigned int)(4) + (bi), (unsigned int)(32 - (2 * 4)))) >> (2 * 4));

      unsigned int t = s_data[hook(5, ai)];
      s_data[hook(5, ai)] = s_data[hook(5, bi)];
      s_data[hook(5, bi)] += t;
    }
  }

  barrier(0x01);

  if (g_ai < n) {
    data[hook(6, g_ai)] = s_data[hook(5, s_ai)];
  }
  if (g_bi < n) {
    data[hook(6, g_bi)] = s_data[hook(5, s_bi)];
  }
}