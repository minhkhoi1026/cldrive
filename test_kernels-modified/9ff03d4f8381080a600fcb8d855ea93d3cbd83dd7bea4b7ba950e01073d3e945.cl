//{"acc":3,"avg_pos":5,"avg_vel":6,"dim":8,"dt":7,"float3":1,"pos":0,"steer":4,"vel":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float length3(float4 vec) {
  return sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
}
float4 normalize3(float4 vec) {
  float4 retv;
  float magi = length3(vec);
  magi = magi < 1.e-8 ? 1. : 1. / magi;
  retv.xyz = vec.xyz * magi;
  retv.w = vec.w;
  return retv;
}

kernel void rules2(global float4* pos, global float4* float3, global float4* vel, global float4* acc, global float4* steer, global float4* avg_pos, global float4* avg_vel, float dt, float dim) {
  unsigned int i = get_global_id(0);
  unsigned int num = get_global_size(0);

  float wcoh = 0.03f;
  float wsep = 0.3f;
  float walign = 0.3f;
  float MAX_SPEED = 3.f;

  float4 p = pos[hook(0, i)];
  float4 v = vel[hook(2, i)];

  steer[hook(4, i)].xyz /= steer[hook(4, i)].w > 0.f ? steer[hook(4, i)].w : 1.f;
  avg_pos[hook(5, i)].xyz /= avg_pos[hook(5, i)].w > 0.f ? avg_pos[hook(5, i)].w : 1.f;
  avg_vel[hook(6, i)].xyz /= avg_vel[hook(6, i)].w > 0.f ? avg_vel[hook(6, i)].w : 1.f;

  float4 sep = normalize3(steer[hook(4, i)]);

  float4 coh = avg_pos[hook(5, i)] - p;
  coh = normalize3(coh);

  float4 align = avg_vel[hook(6, i)] - v;
  align = normalize3(align);

  acc[hook(3, i)] += wcoh * coh + wsep * sep + walign * align;
  float acc_mag = length3(acc[hook(3, i)]);

  float4 acc_norm = normalize3(acc[hook(3, i)]);

  if (acc_mag > MAX_SPEED) {
    acc[hook(3, i)] = acc_norm * MAX_SPEED;
  }
  acc[hook(3, i)].w = 1.f;

  float4 vv = (float4)(-3. * pos[hook(0, i)].y, pos[hook(0, i)].x, 0, 0.);
  vv = vv * .01f;
  vel[hook(2, i)] = vv + acc[hook(3, i)];
}