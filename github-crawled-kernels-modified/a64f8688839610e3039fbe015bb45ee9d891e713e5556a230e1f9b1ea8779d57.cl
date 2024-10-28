//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void function2D(global float4* data) {
  int2 id = (int2)(get_global_id(0), get_global_id(1));
  int2 globalSize = (int2)(get_global_size(0), get_global_size(1));

  float2 point = (float2)(id.x / (float)globalSize.x * 6.0, id.y / (float)globalSize.y * 6.0f);

  data[hook(0, id.x + id.y * globalSize.x)] = (float4)(id.x, id.y, sin(point.x) * cos(point.y), 0);
}