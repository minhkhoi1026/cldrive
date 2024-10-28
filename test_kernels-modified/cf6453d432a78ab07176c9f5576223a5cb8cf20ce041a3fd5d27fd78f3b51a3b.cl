//{"force":2,"gconst":4,"inveps":5,"params":0,"pcache":3,"pos":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gravity_force(global float4* params, global float4* pos, global float4* force, local float4* pcache, float gconst, float inveps) {
  int i = get_global_id(0);
  int il = get_local_id(0);

  int n = get_global_size(0);
  int nl = get_local_size(0);

  int nb = n / nl;

  float4 f0 = force[hook(2, i)];
  float4 fi = (float4)(0, 0, 0, 0);
  float4 p = pos[hook(1, i)];
  float m = params[hook(0, i)].y;

  for (int jb = 0; jb < nb; jb++) {
    pcache[hook(3, il)].xyz = pos[hook(1, jb * nl + il)].xyz;
    pcache[hook(3, il)].w = params[hook(0, jb * nl + il)].y;

    barrier(0x01);

    for (int j = 0; j < nl; j++) {
      float4 p2 = (float4)(pcache[hook(3, j)].xyz, 0);
      float m2 = pcache[hook(3, j)].w;
      float4 d = p2 - p;

      float invr = rsqrt(d.x * d.x + d.y * d.y + d.z * d.z);
      if (invr > inveps) {
        invr = inveps;
      }

      float f = gconst * m * m2 * invr * invr * invr;
      fi += f * d;
    }

    barrier(0x01);
  }

  force[hook(2, i)] = f0 + fi;
}