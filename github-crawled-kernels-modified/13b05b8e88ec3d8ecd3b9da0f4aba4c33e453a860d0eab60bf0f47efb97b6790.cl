//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void partially_uninitialized_fract(global float4* output) {
  float4 f;
  f.xzw = 4.2;
  *(output + 1) = fract(f, output);
}