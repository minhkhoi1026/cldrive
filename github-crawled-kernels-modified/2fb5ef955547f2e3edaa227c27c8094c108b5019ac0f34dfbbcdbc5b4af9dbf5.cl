//{"PBO":0,"blue":3,"green":2,"red":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initializePBO(global float* PBO, private float red, private float green, private float blue) {
  const float4 value = {red, green, blue, 1.0};
  vstore4(value, get_global_id(0), PBO);
}