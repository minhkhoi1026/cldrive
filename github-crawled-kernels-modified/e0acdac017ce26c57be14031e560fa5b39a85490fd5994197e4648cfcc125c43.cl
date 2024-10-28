//{"d_data":1,"d_status":0,"d_status[bid].status":14,"params":3,"params->mask":5,"params->param_tbl":9,"params->param_tbl[bid]":8,"params->pos_tbl":15,"params->sh1_tbl":6,"params->sh2_tbl":7,"params->single_temper_tbl":13,"params->single_temper_tbl[bid]":12,"params->temper_tbl":11,"params->temper_tbl[bid]":10,"size":4,"status":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct mtgp32_kernel_status_t {
  unsigned int status[351];
};

struct mtgp32_param_t {
  unsigned int pos_tbl[200];
  unsigned int param_tbl[200][16];
  unsigned int temper_tbl[200][16];
  unsigned int single_temper_tbl[200][16];
  unsigned int sh1_tbl[200];
  unsigned int sh2_tbl[200];
  unsigned int mask[1];
};
unsigned int para_rec(unsigned int X1, unsigned int X2, unsigned int Y, int bid, constant struct mtgp32_param_t* params) {
  unsigned int X = (X1 & params->mask[hook(5, 0)]) ^ X2;
  unsigned int MAT;

  X ^= X << params->sh1_tbl[hook(6, bid)];
  Y = X ^ (Y >> params->sh2_tbl[hook(7, bid)]);
  MAT = params->param_tbl[hook(9, bid)][hook(8, Y & 15)];
  return Y ^ MAT;
}
unsigned int temper(unsigned int V, unsigned int T, int bid, constant struct mtgp32_param_t* params) {
  unsigned int MAT;

  T ^= T >> 16;
  T ^= T >> 8;
  MAT = params->temper_tbl[hook(11, bid)][hook(10, T & 15)];
  return V ^ MAT;
}
float temper_single(unsigned int V, unsigned int T, int bid, constant struct mtgp32_param_t* params) {
  unsigned int MAT;
  unsigned int r;

  T ^= T >> 16;
  T ^= T >> 8;
  MAT = params->single_temper_tbl[hook(13, bid)][hook(12, T & 15)];
  r = (V >> 9) ^ MAT;
  return __builtin_astype((r), float);
}
void status_read(local unsigned int* status, global const struct mtgp32_kernel_status_t* d_status, int bid, int tid) {
  status[hook(2, (256 * 3) - 351 + tid)] = d_status[hook(0, bid)].status[hook(14, tid)];
  if (tid < 351 - 256) {
    status[hook(2, (256 * 3) - 351 + 256 + tid)] = d_status[hook(0, bid)].status[hook(14, 256 + tid)];
  }
  barrier(0x01);
}
void status_write(global struct mtgp32_kernel_status_t* d_status, local const unsigned int* status, int bid, int tid) {
  d_status[hook(0, bid)].status[hook(14, tid)] = status[hook(2, (256 * 3) - 351 + tid)];
  if (tid < 351 - 256) {
    d_status[hook(0, bid)].status[hook(14, 256 + tid)] = status[hook(2, 4 * 256 - 351 + tid)];
  }
  barrier(0x01);
}
kernel void mtgp32_uint32_kernel(global struct mtgp32_kernel_status_t* d_status, global unsigned int* d_data, local unsigned int* status, constant struct mtgp32_param_t* params, int size) {
  const int bid = get_group_id(0);
  const int tid = get_local_id(0);
  int pos = params->pos_tbl[hook(15, bid)];
  unsigned int r;
  unsigned int o;

  status_read(status, d_status, bid, tid);

  for (int i = 0; i < size; i += (256 * 3)) {
    r = para_rec(status[hook(2, (256 * 3) - 351 + tid)], status[hook(2, (256 * 3) - 351 + tid + 1)], status[hook(2, (256 * 3) - 351 + tid + pos)], bid, params);
    status[hook(2, tid)] = r;
    o = temper(r, status[hook(2, (256 * 3) - 351 + tid + pos - 1)], bid, params);
    d_data[hook(1, size * bid + i + tid)] = o;
    barrier(0x01);
    r = para_rec(status[hook(2, (4 * 256 - 351 + tid) % (256 * 3))], status[hook(2, (4 * 256 - 351 + tid + 1) % (256 * 3))], status[hook(2, (4 * 256 - 351 + tid + pos) % (256 * 3))], bid, params);
    status[hook(2, tid + 256)] = r;
    o = temper(r, status[hook(2, (4 * 256 - 351 + tid + pos - 1) % (256 * 3))], bid, params);
    d_data[hook(1, size * bid + 256 + i + tid)] = o;
    barrier(0x01);
    r = para_rec(status[hook(2, 2 * 256 - 351 + tid)], status[hook(2, 2 * 256 - 351 + tid + 1)], status[hook(2, 2 * 256 - 351 + tid + pos)], bid, params);
    status[hook(2, tid + 2 * 256)] = r;
    o = temper(r, status[hook(2, tid + pos - 1 + 2 * 256 - 351)], bid, params);
    d_data[hook(1, size * bid + 2 * 256 + i + tid)] = o;
    barrier(0x01);
  }

  status_write(d_status, status, bid, tid);
}