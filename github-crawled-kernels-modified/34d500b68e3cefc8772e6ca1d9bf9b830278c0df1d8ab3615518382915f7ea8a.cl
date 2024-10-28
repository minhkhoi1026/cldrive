//{"inForces":1,"inNodes":0,"outNodes":2,"temperature":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void movement(global float4* inNodes, global float4* inForces, global float4* outNodes, const float temperature) {
  unsigned int i = get_global_id(0);
  if (length(inNodes[hook(0, i)]) < 100000) {
    float magnitude = length(inForces[hook(1, i)]);
    if (magnitude > 0.0)
      outNodes[hook(2, i)] = inNodes[hook(0, i)] + temperature * inForces[hook(1, i)] / magnitude;
  }
}