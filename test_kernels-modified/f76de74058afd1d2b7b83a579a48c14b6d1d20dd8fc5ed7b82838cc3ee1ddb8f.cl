//{"Dvals":2,"damp":5,"dt":4,"hf":0,"niters":3,"points":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t s0 = 0 | 2 | 0x20;
kernel void relaxPoints(read_only image2d_t hf, global float2* points, global float2* Dvals, int niters, float dt, float damp) {
  float2 p = points[hook(1, get_global_id(0))];
  float2 v = (float2)(0.0f, 0.0f);
  float2 f;
  for (int i = 0; i < niters; i++) {
    f = read_imagef(hf, s0, p).xy;
    v *= damp;
    v -= f * dt;
    p += v * dt;
  }
  points[hook(1, get_global_id(0))] = p;
}