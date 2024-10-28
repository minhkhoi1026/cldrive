//{"Dvals":2,"hf":0,"points":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t s0 = 0 | 2 | 0x20;
kernel void getF2InPoints(read_only image2d_t hf, global float2* points, global float2* Dvals) {
  const float2 coord = points[hook(1, get_global_id(0))];
  Dvals[hook(2, get_global_id(0))] = read_imagef(hf, s0, coord).xy;
}