//{"float3":1,"framebuffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clear(global float4* framebuffer, float4 float3) {
  int pos = get_global_id(0);
  framebuffer[hook(0, pos)] = float3;
}