//{"input":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_wrappers(global char* output, global float* input) {
  local int offset;
  global float** ptr = &input;

  for (int c = 0; c < 16; ++c) {
    input[hook(1, c)] = c + 1;
  }

  offset = 0;

  float4 r1 = vload4(offset, (*ptr));

  offset = 1;

  float4 r2 = vload4(offset, (*ptr));

  offset = 2;

  float4 r3 = vload4(offset, (*ptr));

  output[hook(0, 0)] = r1.x;
  output[hook(0, 1)] = r1.y;
  output[hook(0, 2)] = r1.z;
  output[hook(0, 3)] = r1.w;

  output[hook(0, 4)] = r2.x;
  output[hook(0, 5)] = r2.y;
  output[hook(0, 6)] = r2.z;
  output[hook(0, 7)] = r2.w;

  output[hook(0, 8)] = r3.x;
  output[hook(0, 9)] = r3.y;
  output[hook(0, 10)] = r3.z;
  output[hook(0, 11)] = r3.w;
}