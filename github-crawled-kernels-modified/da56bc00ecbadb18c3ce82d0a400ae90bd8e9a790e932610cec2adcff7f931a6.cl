//{"scaleBias":1,"vertices":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scaleBiasVertices(global float* vertices, float4 scaleBias) {
  unsigned int gid = get_global_id(0);
  float3 vertex = vload3(gid, vertices);
  vertex = fma(vertex, scaleBias.w, scaleBias.xyz);
  vstore3(vertex, gid, vertices);
}