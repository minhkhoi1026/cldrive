//{"baseColor":3,"colorArray":1,"deltaTime":8,"lifetimeArray":2,"par":4,"posArray":0,"rayDir":6,"rayOrigin":5,"time":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelStep(global float4* posArray, global float4* colorArray, global float* lifetimeArray, float4 baseColor, float4 par, float4 rayOrigin, float4 rayDir, float time, float deltaTime) {
  int gid = get_global_id(0);

  float4 pos = posArray[hook(0, gid)];

  const float lifetime = 30.;

  lifetimeArray[hook(2, gid)] -= deltaTime;
  if (lifetimeArray[hook(2, gid)] < 0) {
    lifetimeArray[hook(2, gid)] = lifetime;
    float r = 0.005 * (((float)gid) / 10000. + 100.);
    int num = gid % 10000;
    float phi = 0.02 * 3.14159 * (gid % 100);
    num = num / 100;
    float theta = 0.01 * 3.14159 * ((float)num);
    float sintheta = sin(theta);
    float4 offset = (float4)(r * sintheta * cos(phi), r * sintheta * sin(phi), r * cos(theta), 0.0);
    pos = rayOrigin + 100.0f * rayDir + 0.2f * offset;
  }

  float4 vel = (float4)(par.x * (pos.y - pos.x), pos.x * (par.z - pos.z) - pos.y, pos.y * pos.x - par.y * pos.z, 0);

  posArray[hook(0, gid)] = pos + vel * (deltaTime * par.w);

  colorArray[hook(1, gid)] = baseColor + 0.1f * fast_normalize(vel);

  const float decayTime = 1.0;
  const float birthTime = 1.0;

  if (lifetimeArray[hook(2, gid)] < decayTime) {
    colorArray[hook(1, gid)].w *= lifetimeArray[hook(2, gid)] / decayTime;
  } else if (lifetimeArray[hook(2, gid)] > lifetime - birthTime) {
    float tmp = (lifetime - lifetimeArray[hook(2, gid)]) / birthTime;
    colorArray[hook(1, gid)].w *= 2.0 * (1.0 - 4.0 * (tmp - 0.5) * (tmp - 0.5)) + tmp;
  }
}