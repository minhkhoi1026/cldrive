//{"cache":10,"cache[l.y + 1]":11,"cache[l.y]":9,"input":0,"inputStart":1,"inputStride":2,"outHeight":8,"outWidth":7,"output":3,"outputStart0":4,"outputStart1":5,"outputStride":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(32, 8, 1))) kernel void quadToComplex(global const float* input, unsigned int inputStart, unsigned int inputStride, global float2* output, unsigned int outputStart0, unsigned int outputStart1, unsigned int outputStride, unsigned int outWidth, unsigned int outHeight) {
  const int2 g = (int2)(get_global_id(0), get_global_id(1));
  const int2 l = (int2)(get_local_id(0), get_local_id(1));

  local float cache[8][32];

  cache[hook(10, l.y)][hook(9, l.x)] = input[hook(0, g.y * inputStride + g.x + inputStart)];

  int2 outPos = g >> 1;

  barrier(0x01);

  if (all(outPos < (int2)(outWidth, outHeight)) & !(g.x & 1) & !(g.y & 1)) {
    float ul = cache[hook(10, l.y)][hook(9, l.x)];
    float ur = cache[hook(10, l.y)][hook(9, l.x + 1)];
    float ll = cache[hook(10, l.y + 1)][hook(11, l.x)];
    float lr = cache[hook(10, l.y + 1)][hook(11, l.x + 1)];

    const float factor = 1.0f / sqrt(2.0f);

    const size_t loc = outPos.y * outputStride + outPos.x;
    output[hook(3, loc + outputStart0)] = factor * (float2)(ul - lr, ur + ll);
    output[hook(3, loc + outputStart1)] = factor * (float2)(ul + lr, ur - ll);
  }
}