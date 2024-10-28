//{"Ps":5,"bounds":3,"force":2,"nx":0,"order":4,"pos":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 pair_force(float2 p1, float2 p2) {
  float2 d = p2 - p1;
  float r2 = dot(d, d);
  if (r2 > 3.24)
    return (float2)(0.0f, 0.0f);
  float ir2 = 1 / (r2 + 1.0e-2);
  float fr = (0.7 - ir2) * (3.24 - r2);
  return d * fr;
}

kernel void force_Tiled_Sorted(unsigned int nx, global float2* pos, global float2* force, global int2* bounds, global int* order) {
  local float2 Ps[256];
  const int iG = get_global_id(0);
  const int iL = get_local_id(0);
  const int nL = get_local_size(0);

  int icell = get_group_id(0);

  icell = order[hook(4, icell)];
  int2 bound0 = bounds[hook(3, icell)];
  int njs = 0;
  {
    int2 bound = bound0;
    for (int i0 = 0; i0 < bound.y; i0 += nL) {
      int i = i0 + iL;
      if (i >= bound.y)
        break;
      Ps[hook(5, njs + i)] = pos[hook(1, bound.x + i)];
    }
    njs += bound.y;
  };
  {
    int2 bound = bounds[hook(3, icell - 1)];
    for (int i0 = 0; i0 < bound.y; i0 += nL) {
      int i = i0 + iL;
      if (i >= bound.y)
        break;
      Ps[hook(5, njs + i)] = pos[hook(1, bound.x + i)];
    }
    njs += bound.y;
  };
  {
    int2 bound = bounds[hook(3, icell + 1)];
    for (int i0 = 0; i0 < bound.y; i0 += nL) {
      int i = i0 + iL;
      if (i >= bound.y)
        break;
      Ps[hook(5, njs + i)] = pos[hook(1, bound.x + i)];
    }
    njs += bound.y;
  };
  {
    int2 bound = bounds[hook(3, icell - nx - 1)];
    for (int i0 = 0; i0 < bound.y; i0 += nL) {
      int i = i0 + iL;
      if (i >= bound.y)
        break;
      Ps[hook(5, njs + i)] = pos[hook(1, bound.x + i)];
    }
    njs += bound.y;
  };
  {
    int2 bound = bounds[hook(3, icell - nx)];
    for (int i0 = 0; i0 < bound.y; i0 += nL) {
      int i = i0 + iL;
      if (i >= bound.y)
        break;
      Ps[hook(5, njs + i)] = pos[hook(1, bound.x + i)];
    }
    njs += bound.y;
  };
  {
    int2 bound = bounds[hook(3, icell - nx + 1)];
    for (int i0 = 0; i0 < bound.y; i0 += nL) {
      int i = i0 + iL;
      if (i >= bound.y)
        break;
      Ps[hook(5, njs + i)] = pos[hook(1, bound.x + i)];
    }
    njs += bound.y;
  };
  {
    int2 bound = bounds[hook(3, icell + nx - 1)];
    for (int i0 = 0; i0 < bound.y; i0 += nL) {
      int i = i0 + iL;
      if (i >= bound.y)
        break;
      Ps[hook(5, njs + i)] = pos[hook(1, bound.x + i)];
    }
    njs += bound.y;
  };
  {
    int2 bound = bounds[hook(3, icell + nx)];
    for (int i0 = 0; i0 < bound.y; i0 += nL) {
      int i = i0 + iL;
      if (i >= bound.y)
        break;
      Ps[hook(5, njs + i)] = pos[hook(1, bound.x + i)];
    }
    njs += bound.y;
  };
  {
    int2 bound = bounds[hook(3, icell + nx + 1)];
    for (int i0 = 0; i0 < bound.y; i0 += nL) {
      int i = i0 + iL;
      if (i >= bound.y)
        break;
      Ps[hook(5, njs + i)] = pos[hook(1, bound.x + i)];
    }
    njs += bound.y;
  };

  barrier(0x01);

  for (int i0 = 0; i0 < bound0.y; i0 += nL) {
    int i = i0 + iL;
    if (i >= bound0.y)
      break;
    float2 pi = Ps[hook(5, i)];
    float2 f = (float2)(0.0f, 0.0f);
    for (int j = 0; j < njs; j++) {
      f += pair_force(pi, Ps[hook(5, j)]);
    }
    force[hook(2, bound0.x + i)] = f;
  }
}