//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ffill(global float4* a) {
  unsigned int i = get_global_id(0);
  a[hook(0, i)].x = 0.0f;
  a[hook(0, i)].y = 1.0f;
  a[hook(0, i)].z = 2.0f;
  a[hook(0, i)].w = 3.0f;
}