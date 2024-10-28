//{"aux":1,"in":0,"radius":3,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_max_hor(global const float4* in, global float4* aux, int width, int radius) {
  const int in_index = get_global_id(0) * (width + 2 * radius) + (radius + get_global_id(1));

  const int aux_index = get_global_id(0) * width + get_global_id(1);
  int i;
  float4 max;
  float4 in_v;

  max = (float4)(-0x1.fffffep127f);

  if (get_global_id(1) < width) {
    for (i = -radius; i <= radius; i++) {
      in_v = in[hook(0, in_index + i)];
      max = max < in_v ? in_v : max;
    }
    aux[hook(1, aux_index)] = max;
  }
}