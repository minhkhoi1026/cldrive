//{"aux":0,"out":1,"radius":3,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_blur_ver(global const float4* aux, global float4* out, int width, int radius) {
  const int out_index = get_global_id(0) * width + get_global_id(1);
  int i;
  float4 mean;

  mean = (float4)(0.0f);
  int aux_index = get_global_id(0) * width + get_global_id(1);

  if (get_global_id(1) < width) {
    for (i = -radius; i <= radius; i++) {
      mean += aux[hook(0, aux_index)];
      aux_index += width;
    }
    out[hook(1, out_index)] = mean / (2 * radius + 1);
  }
}