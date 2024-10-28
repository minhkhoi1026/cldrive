//{"P":0,"Q":1,"in":2,"out":3,"tempbuff":5,"tempbuff[tx]":4,"tempbuff[ty]":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose(const int P, const int Q, const global float* in, global float* out) {
  const int tx = get_local_id(0);
  const int ty = get_local_id(1);
  const int ID0 = get_group_id(0) * 16 + tx;
  const int ID1 = get_group_id(1) * 16 + ty;

  local float tempbuff[16][16];

  if (ID0 < P && ID1 < Q) {
    tempbuff[hook(5, tx)][hook(4, ty)] = in[hook(2, ID0 * Q + ID1)];
  }

  barrier(0x01);

  const int nID0 = get_group_id(1) * 16 + tx;
  const int nID1 = get_group_id(0) * 16 + ty;

  if (nID0 < Q && nID1 < P) {
    out[hook(3, nID0 * P + nID1)] = tempbuff[hook(5, ty)][hook(6, tx)];
  }
}