//{"count":2,"inNodes":0,"k":3,"outDirections":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void repulsion(global float4* inNodes, global float4* outDirections, const unsigned long count, const float k) {
  unsigned int i = get_global_id(0);
  float4 f = (float4)(0.0);
  for (unsigned long j = 0; j < count; j++) {
    if (i != j) {
      float4 direction = inNodes[hook(0, i)] - inNodes[hook(0, j)];
      float magnitude = length(direction);
      if (magnitude > 0.0)
        f += (direction / magnitude) * (k * k / magnitude);
    }
  }
  outDirections[hook(1, i)] = f;
}