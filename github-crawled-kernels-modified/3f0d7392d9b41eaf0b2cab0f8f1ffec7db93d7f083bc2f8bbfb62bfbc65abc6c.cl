//{"P":0,"P_XL":3,"Q":1,"Q_XL":4,"in":2,"out":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void zeroPad(const int P, const int Q, const global float* in, const int P_XL, const int Q_XL, global float* out) {
  const int tx = get_group_id(0) * 16 + get_local_id(0);
  const int ty = get_group_id(1) * 16 + get_local_id(1);

  if (tx < P_XL && ty < Q_XL) {
    float value;
    if (tx < P && ty < Q) {
      value = in[hook(2, tx * Q + ty)];
    } else {
      value = 0.0f;
    }

    out[hook(5, tx * Q_XL + ty)] = value;
  }
}