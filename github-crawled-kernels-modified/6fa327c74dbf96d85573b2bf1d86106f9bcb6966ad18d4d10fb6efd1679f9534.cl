//{"d_pos":2,"d_prevPos":3,"elapsedTime":4,"height":1,"prevElapsedTime":5,"simulationTime":6,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Integrate(unsigned int width, unsigned int height, global float4* d_pos, global float4* d_prevPos, float elapsedTime, float prevElapsedTime, float simulationTime) {
  if (get_global_id(0) >= width || get_global_id(1) >= height) {
    return;
  }

  unsigned int particleID = get_global_id(0) + get_global_id(1) * width;

  if (particleID > width - 1 || (particleID & (7)) != 0) {
    float4 xprev = d_prevPos[hook(3, particleID)];
    float4 x0 = d_pos[hook(2, particleID)];

    float4 v0 = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
    if (prevElapsedTime > 0) {
      v0 = (x0 - xprev) * (1 / prevElapsedTime);
    }
    float4 a0 = (float4)(sin(simulationTime * 2) / 2 + 1, 0.0f, cos(simulationTime * 3) - 2, 0.0f) * 0.3f + (float4)(0.f, -9.81f, 0.f, 0.f);

    float dt = elapsedTime;
    float4 x1 = x0 + v0 * dt + 0.5f * a0 * dt * dt;

    d_prevPos[hook(3, particleID)] = x0;
    d_pos[hook(2, particleID)] = x1;
  }
}