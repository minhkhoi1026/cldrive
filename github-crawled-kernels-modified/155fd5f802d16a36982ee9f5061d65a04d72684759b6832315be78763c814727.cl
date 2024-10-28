//{"a":3,"div":4,"img_in":0,"img_out":1,"previous_in":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samplerA = 0 | 4 | 0x10;
const sampler_t samplerB = 1 | 6 | 0x20;
kernel void diffuse(read_only image2d_t img_in, write_only image2d_t img_out, read_only image2d_t previous_in, float a, float div) {
  const int xpos = get_global_id(0);
  const int ypos = get_global_id(1);
  float4 dprev = read_imagef(previous_in, samplerA, (int2)(xpos, ypos));
  float4 dl = read_imagef(img_in, samplerA, (int2)(xpos - 1, ypos));
  float4 dr = read_imagef(img_in, samplerA, (int2)(xpos + 1, ypos));
  float4 du = read_imagef(img_in, samplerA, (int2)(xpos, ypos - 1));
  float4 dd = read_imagef(img_in, samplerA, (int2)(xpos, ypos + 1));
  float val = (dprev.x + a * (dl.x + dr.x + du.x + dd.x)) / div;
  write_imagef(img_out, (int2)(xpos, ypos), (float4)(val, 0, 0, 0));
}