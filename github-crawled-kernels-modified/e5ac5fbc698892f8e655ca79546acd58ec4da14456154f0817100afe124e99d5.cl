//{"A":0,"A_alphabetaB":1,"ConstA":3,"ConstB":4,"N":5,"blk_result":2,"lds":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_A_mul_alphabetaB(global const float* A, global float* A_alphabetaB, global float* blk_result, constant float* ConstA, constant float* ConstB, const int N) {
  size_t lx = get_local_id(0);
  size_t ly = get_local_id(1);

  size_t gx = get_group_id(0) * get_local_size(0) + lx;
  size_t gy = get_group_id(1) * get_local_size(1) + ly;

  float data;

  unsigned int outID = gy * N + gx;
  volatile local float lds[256];

  data = A[hook(0, outID)] * ConstA[hook(3, gy)] * ConstB[hook(4, gx)];
  A_alphabetaB[hook(1, outID)] = data;

  unsigned int index = ly * 16 + lx;
  lds[hook(6, index)] = data;

  barrier(0x01);

  if (lx < 8) {
    lds[hook(6, index)] += lds[hook(6, index + 8)];
  }
  if (lx < 4) {
    lds[hook(6, index)] += lds[hook(6, index + 4)];
  }
  if (lx < 2) {
    lds[hook(6, index)] += lds[hook(6, index + 2)];
  }
  if (lx < 1) {
    lds[hook(6, index)] += lds[hook(6, index + 1)];
  }
  if (lx == 0 && ly == 0) {
    int id = get_group_id(1) * get_local_size(0) + get_group_id(0);
    blk_result[hook(2, id)] = lds[hook(6, 0)] + lds[hook(6, 16)] + lds[hook(6, 32)] + lds[hook(6, 48)] + lds[hook(6, 64)] + lds[hook(6, 80)] + lds[hook(6, 96)] + lds[hook(6, 112)] + lds[hook(6, 128)] + lds[hook(6, 144)] + lds[hook(6, 160)] + lds[hook(6, 176)] + lds[hook(6, 192)] + lds[hook(6, 208)] + lds[hook(6, 224)] + lds[hook(6, 240)];
  }
}