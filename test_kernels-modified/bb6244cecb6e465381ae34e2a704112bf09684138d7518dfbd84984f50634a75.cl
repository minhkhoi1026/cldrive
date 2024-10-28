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

kernel void rules1(global float4* pos, global float4* float3, global float4* vel, global float4* acc, global float4* steer, global float4* avg_pos, global float4* avg_vel, float dt, float dim) {
  unsigned int i = get_global_id(0);
  unsigned int num = get_global_size(0);

  float h = 30.;
  float desired_sep = 20.;

  float4 p = pos[hook(0, i)];
  float4 v = vel[hook(2, i)];

  steer[hook(4, i)] = (float4)(0., 0., 0., 0.);
  avg_pos[hook(5, i)] = (float4)(0., 0., 0., 0.);
  avg_vel[hook(6, i)] = (float4)(0., 0., 0., 0.);

  for (int j = 0; j < num; j++) {
    float4 diff = p - pos[hook(0, j)];
    float d = length3(diff);
    if (d < h) {
      avg_pos[hook(5, i)].xyz += pos[hook(0, j)].xyz;
      avg_pos[hook(5, i)].w += 1;
      avg_vel[hook(6, i)].xyz += vel[hook(2, j)].xyz;
      avg_vel[hook(6, i)].w += 1;

      if (d < desired_sep && d != 0.) {
        diff /= d * d;
        steer[hook(4, i)].xyz += diff.xyz;
        steer[hook(4, i)].w += 1;
      }
    }
  }
}