//{"densityBuffer":3,"gridResolution":0,"pressureBuffer":2,"velocityBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float dt = 0.1f;
kernel void resetSimulation(const int gridResolution, global float2* velocityBuffer, global float* pressureBuffer, global float4* densityBuffer) {
  int2 id = (int2)(get_global_id(0), get_global_id(1));

  if (id.x < gridResolution && id.y < gridResolution) {
    velocityBuffer[hook(1, id.x + id.y * gridResolution)] = (float2)(0.0f);
    pressureBuffer[hook(2, id.x + id.y * gridResolution)] = 0.0f;
    densityBuffer[hook(3, id.x + id.y * gridResolution)] = (float4)(0.0f);
  }
}