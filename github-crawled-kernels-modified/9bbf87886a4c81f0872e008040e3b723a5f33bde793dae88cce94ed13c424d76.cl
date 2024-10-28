//{"add":4,"img_in":0,"img_out":1,"px":2,"py":3,"radius":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samplerA = 0 | 4 | 0x10;
const sampler_t samplerB = 1 | 6 | 0x20;
kernel void addCircleValue(read_only image2d_t img_in, write_only image2d_t img_out, int px, int py, float add, float radius) {
  const int xpos = get_global_id(0);
  const int ypos = get_global_id(1);
  const float dx = (float)xpos - px;
  const float dy = (float)ypos - py;

  if (dx * dx + dy * dy <= radius * radius) {
    float4 value = read_imagef(img_in, samplerA, (int2)(xpos, ypos));
    value.x += add;
    write_imagef(img_out, (int2)(xpos, ypos), value);
  }
}