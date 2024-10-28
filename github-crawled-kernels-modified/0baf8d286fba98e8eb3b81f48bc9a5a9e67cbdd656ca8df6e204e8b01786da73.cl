//{"A":0,"As":3,"B":1,"Bs":4,"C":2,"ha":6,"wa":5,"wb":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixMul(global float* A, global float* B, global float* C, local float* As, local float* Bs, unsigned int wa, unsigned int ha, unsigned int wb) {
  int bx = get_group_id(0);
  int by = get_group_id(1);

  int tx = get_local_id(0);
  int ty = get_local_id(1);

  int gx = get_global_id(0);
  int gy = get_global_id(1);

  unsigned int block_w = ((wb - bx * 64) < (64) ? (wb - bx * 64) : (64));
  unsigned int block_h = ((ha - by * 64) < (64) ? (ha - by * 64) : (64));

  int valid = (gx < wb && gy < ha);

  float Csub = (float)0.0;

  unsigned int pos = 0;
  while (pos < wa) {
    unsigned int size = ((wa - pos) < (64) ? (wa - pos) : (64));
    if (tx < size && gy < ha)
      As[hook(3, ty * 64 + tx)] = A[hook(0, pos + tx + wa * gy)];
    if (ty < size && gx < wb)
      Bs[hook(4, ty * 64 + tx)] = B[hook(1, gx + wb * (pos + ty))];

    barrier(0x01);

    if (valid) {
      for (int k = 0; k < size; ++k)
        Csub += As[hook(3, ty * 64 + k)] * Bs[hook(4, k * 64 + tx)];
    }
    pos += size;
    barrier(0x01);
  }

  if (valid)
    C[hook(2, wb * gy + gx)] = Csub;
}