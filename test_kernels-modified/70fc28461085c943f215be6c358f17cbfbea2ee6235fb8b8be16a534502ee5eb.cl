//{"count":3,"inEdges":1,"inNodes":0,"k":4,"outDirections":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void attraction(global float4* inNodes, global ulong2* inEdges, global float4* outDirections, const unsigned long count, const float k) {
  unsigned int i = get_global_id(0);
  unsigned long src = inEdges[hook(1, i)].x;
  unsigned long dst = inEdges[hook(1, i)].y;
  float4 pos1 = inNodes[hook(0, src)];
  float4 int2 = inNodes[hook(0, dst)];
  float4 direction = pos1 - int2;
  float magnitude = length(direction);
  if (magnitude > 100.0) {
    outDirections[hook(2, src)] -= direction * magnitude / k;
    outDirections[hook(2, dst)] += direction * magnitude / k;
  }
}