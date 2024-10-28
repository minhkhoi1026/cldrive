//{"a":0,"b":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bigDot(global float2* a, global float2* b, global float* out) {
  int id = get_global_id(0);
  out[hook(2, id)] = dot(a[hook(0, id)], b[hook(1, id)]);

  float sum = 0.0f;
  if (id == 0) {
    for (int i = 0; i < get_global_size(0); ++i)
      sum += out[hook(2, i)];

    out[hook(2, id)] = sum;
  }
}