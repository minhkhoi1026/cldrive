//{"mat":1,"v":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void householder(float4 v, global float4* mat) {
  v *= 1.41421356237309504880168872420969808f / length(v);
  mat[hook(1, 0)] = (float4)(1.0f, 0.0f, 0.0f, 0.0f) - (v * v.x);
  mat[hook(1, 1)] = (float4)(0.0f, 1.0f, 0.0f, 0.0f) - (v * v.y);
  mat[hook(1, 2)] = (float4)(0.0f, 0.0f, 1.0f, 0.0f) - (v * v.z);
  mat[hook(1, 3)] = (float4)(0.0f, 0.0f, 0.0f, 1.0f) - (v * v.w);
}