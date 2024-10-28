//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_square(global float4* input, global float4* output) {
  int i = get_global_id(0);
  output[hook(1, i)] = input[hook(0, i)] * input[hook(0, i)];
  float4 f4 = output[hook(1, i)];
  printf("%0.1f,%0.1f,%0.1f,%0.1f,", f4.x, f4.y, f4.z, f4.w);
}