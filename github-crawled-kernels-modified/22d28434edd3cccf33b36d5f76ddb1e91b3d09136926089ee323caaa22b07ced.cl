//{"aux":1,"in":0,"radius":3,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_blur_hor(global const float4* in, global float4* aux, int width, int radius) {
  const int in_index = get_global_id(0) * (width + 2 * radius) + (radius + get_global_id(1));

  const int aux_index = get_global_id(0) * width + get_global_id(1);
  int i;
  float4 mean;

  mean = (float4)(0.0f);

  if (get_global_id(1) < width) {
    for (i = -radius; i <= radius; i++) {
      mean += in[hook(0, in_index + i)];
    }
    aux[hook(1, aux_index)] = mean / (float)(2 * radius + 1);
  }
}