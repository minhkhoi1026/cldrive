//{"a":0,"b":1,"c":2,"d":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dot_product_child(global const float4* a, global const float4* b, global float* c, global float4* d) {
  int gid = get_global_id(0);
  float4 prod = a[hook(0, gid)] * d[hook(3, gid)];
  c[hook(2, gid)] = prod.x + prod.y + prod.z + prod.w;
}