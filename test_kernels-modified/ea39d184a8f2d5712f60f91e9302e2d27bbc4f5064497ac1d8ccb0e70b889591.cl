//{"in":0,"out":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void real_to_complex(global float* in, global float2* out, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    float2 val = 0;
    val.x = in[hook(0, i)];
    out[hook(1, i)] = val;
  }
}