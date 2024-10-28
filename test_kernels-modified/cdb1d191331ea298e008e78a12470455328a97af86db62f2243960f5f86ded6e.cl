//{"a":0,"b":1,"result":3,"result4":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float4* a, global float4* b, global float4* result4, global float* result) {
  result[hook(3, 0)] = dot(a[hook(0, 0)], b[hook(1, 0)]);
  result4[hook(2, 1)] = cross(a[hook(0, 1)], b[hook(1, 1)]);
  result[hook(3, 2)] = distance(a[hook(0, 2)], b[hook(1, 2)]);
  result[hook(3, 3)] = length(a[hook(0, 3)]);
  result4[hook(2, 4)] = normalize(a[hook(0, 4)]);
  result[hook(3, 5)] = fast_distance(a[hook(0, 5)], b[hook(1, 5)]);
  result[hook(3, 6)] = fast_length(a[hook(0, 6)]);
  result4[hook(2, 7)] = fast_normalize(a[hook(0, 7)]);
}