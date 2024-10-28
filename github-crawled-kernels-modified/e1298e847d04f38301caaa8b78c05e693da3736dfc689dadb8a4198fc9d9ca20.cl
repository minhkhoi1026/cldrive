//{"P":0,"P_XS":3,"Q":1,"Q_XS":4,"in":2,"out":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void zeroTrim(const int P, const int Q, const global float* in, const int P_XS, const int Q_XS, global float* out) {
  const int tx = get_group_id(0) * 16 + get_local_id(0);
  const int ty = get_group_id(1) * 16 + get_local_id(1);

  if (tx < P_XS && ty < Q_XS) {
    out[hook(5, tx * Q_XS + ty)] = in[hook(2, tx * Q + ty)];
  }
}