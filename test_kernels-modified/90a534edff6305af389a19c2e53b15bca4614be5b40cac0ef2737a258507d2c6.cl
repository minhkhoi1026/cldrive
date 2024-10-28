//{"V":6,"dev_vol":0,"number_of_verti":2,"structure":1,"vol_dim":3,"vol_offset":4,"vol_spacing":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int isLeft(const float2 P0, const float2 P1, const float2 P2) {
  return ((P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y));
}

inline int wn_PnPoly(const float2 P, constant float2* V, const ulong n) {
  int wn = 0;

  for (ulong i = 0; i < n; i++) {
    if (V[hook(6, i)].y <= P.y) {
      if (V[hook(6, i + 1)].y > P.y)
        if (isLeft(V[hook(6, i)], V[hook(6, i + 1)], P) > 0)
          ++wn;
    } else {
      if (V[hook(6, i + 1)].y <= P.y)
        if (isLeft(V[hook(6, i)], V[hook(6, i + 1)], P) < 0)
          --wn;
    }
  }
  return wn;
}

kernel void crop_by_struct_kernel(global ushort* dev_vol, constant float2* structure, const ulong number_of_verti, const ulong4 vol_dim, const float2 vol_offset, const float2 vol_spacing) {
  const ulong id = get_global_id(0);

  if (id >= vol_dim.x * vol_dim.y) {
    return;
  }

  if (number_of_verti < 3) {
    dev_vol[hook(0, id)] = 0;
    return;
  }

  const ulong j = id / vol_dim.x;
  const ulong i = id - j * vol_dim.x;

  float2 vp;
  vp.x = vol_offset.x + (i * vol_spacing.x);
  vp.y = vol_offset.y + (j * vol_spacing.y);

  if (wn_PnPoly(vp, structure, number_of_verti) == 0) {
    dev_vol[hook(0, id)] = 0;
  }
}