//{"vectors":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void normalize_vec4(global float4* vectors) {
  int i = get_global_id(0);
  vectors[hook(0, i)] = normalize(vectors[hook(0, i)]);
}