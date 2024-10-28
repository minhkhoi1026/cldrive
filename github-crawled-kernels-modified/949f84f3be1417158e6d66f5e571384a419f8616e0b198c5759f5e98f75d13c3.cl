//{"depth":4,"dt":5,"height":3,"velocity":1,"velocity_out":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void advect3D(global float* velocity_out, global float* velocity, int width, int height, int depth, float dt) {
  const int3 pos = (int3)(get_global_id(0), get_global_id(1), get_global_id(2));
  const float3 dt0 = dt * (float3)(width, height, depth);
  const int wh = width * height;
  const int index = pos.x + pos.y * width + pos.z * wh;
  float3 vvv = (float3)(velocity[hook(1, 3 * index)], velocity[hook(1, 3 * index + 1)], velocity[hook(1, 3 * index + 2)]);
  float3 dpos = (float3)(pos.x, pos.y, pos.z) - dt0 * vvv;
  dpos.x = clamp(dpos.x, 0.5f, width + 0.5f);
  dpos.y = clamp(dpos.y, 0.5f, height + 0.5f);
  dpos.z = clamp(dpos.z, 0.5f, depth + 0.5f);
  int3 vi = (int3)(dpos.x, dpos.y, dpos.z);

  float3 rest = dpos - (float3)(vi.x, vi.y, vi.z);
  float3 org = (float3)(1.0f, 1.0f, 1.0f) - rest;

  for (int i = 0; i < 3; ++i) {
    float input000 = velocity[hook(1, 3 * (vi.x + vi.y * width + vi.z * wh) + i)];
    float input010 = velocity[hook(1, 3 * (vi.x + (vi.y + 1) * width + vi.z * wh) + i)];
    float input100 = velocity[hook(1, 3 * (vi.x + 1 + vi.y * width + vi.z * wh) + i)];
    float input110 = velocity[hook(1, 3 * (vi.x + 1 + (vi.y + 1) * width + vi.z * wh) + i)];
    float input001 = velocity[hook(1, 3 * (vi.x + vi.y * width + (vi.z + 1) * wh) + i)];
    float input011 = velocity[hook(1, 3 * (vi.x + (vi.y + 1) * width + (vi.z + 1) * wh) + i)];
    float input101 = velocity[hook(1, 3 * (vi.x + 1 + vi.y * width + (vi.z + 1) * wh) + i)];
    float input111 = velocity[hook(1, 3 * (vi.x + 1 + (vi.y + 1) * width + (vi.z + 1) * wh) + i)];

    float value = org.x * org.y * org.z * input000 + org.x * rest.y * org.z * input010 + rest.x * org.y * org.z * input100 + rest.x * rest.y * org.z * input110 + org.x * org.y * rest.z * input001 + org.x * rest.y * rest.z * input011 + rest.x * org.y * rest.z * input101 + rest.x * rest.y * rest.z * input111;
    velocity_out[hook(0, 3 * index + i)] = value;
  }
}