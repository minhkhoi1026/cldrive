//{"vec":0,"w":4,"x":1,"y":2,"z":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_vector(global float4* vec, float x, float y, float z, float w) {
  int i = get_global_id(0);
  vec[hook(0, i)] = (float4)(x, y, z, w);
}