//{"aux":0,"out":1,"radius":3,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_min_ver(global const float4* aux, global float4* out, int width, int radius) {
  const int out_index = get_global_id(0) * width + get_global_id(1);
  int aux_index = out_index;
  int i;
  float4 min;
  float4 aux_v;

  min = (float4)(0x1.fffffep127f);

  if (get_global_id(1) < width) {
    for (i = -radius; i <= radius; i++) {
      aux_v = aux[hook(0, aux_index)];
      min = min > aux_v ? aux_v : min;
      aux_index += width;
    }
    out[hook(1, out_index)] = min;
  }
}