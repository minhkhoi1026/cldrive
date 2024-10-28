//{"gain":5,"input":0,"output":4,"padding":2,"start":1,"stride":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void absToRGBA(const global float2* input, unsigned int start, unsigned int padding, unsigned int stride, write_only image2d_t output, float gain) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  if (all(pos < get_image_dim(output))) {
    float v = gain * fast_length(input[hook(0, start + pos.x + stride * pos.y)]);
    write_imagef(output, pos, (float4)(v, v, v, 1.0f));
  }
}