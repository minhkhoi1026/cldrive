//{"clf":5,"cli":6,"gp":4,"num":0,"pos_u":1,"sort_hashes":2,"sort_indexes":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct GridParams {
  float4 grid_size;
  float4 grid_min;
  float4 grid_max;
  float4 bnd_min;
  float4 bnd_max;

  float4 grid_res;
  float4 grid_delta;

  int nb_cells;
};
int4 calcGridCell(float4 p, float4 grid_min, float4 grid_delta) {
  float4 pp;
  pp.x = (p.x - grid_min.x) * grid_delta.x;
  pp.y = (p.y - grid_min.y) * grid_delta.y;
  pp.z = (p.z - grid_min.z) * grid_delta.z;
  pp.w = (p.w - grid_min.w) * grid_delta.w;

  int4 ii;
  ii.x = (int)pp.x;
  ii.y = (int)pp.y;
  ii.z = (int)pp.z;
  ii.w = (int)pp.w;
  return ii;
}

int calcGridHash(int4 gridPos, float4 grid_res, bool wrapEdges

) {
  int gx;
  int gy;
  int gz;

  if (wrapEdges) {
    int gsx = (int)floor(grid_res.x);
    int gsy = (int)floor(grid_res.y);
    int gsz = (int)floor(grid_res.z);

    gx = gridPos.x % gsx;
    gy = gridPos.y % gsy;
    gz = gridPos.z % gsz;
    if (gx < 0)
      gx += gsx;
    if (gy < 0)
      gy += gsy;
    if (gz < 0)
      gz += gsz;
  } else {
    gx = gridPos.x;
    gy = gridPos.y;
    gz = gridPos.z;
  }
  return (gz * grid_res.y + gy) * grid_res.x + gx;
}
kernel void hash(

    int num, global float4* pos_u, global unsigned int* sort_hashes, global unsigned int* sort_indexes,

    constant struct GridParams* gp, global float4* clf, global int4* cli

) {
  unsigned int index = get_global_id(0);

  if (index >= num)
    return;
  float4 p = pos_u[hook(1, index)];

  int4 gridPos = calcGridCell(p, gp[hook(4, 0)].grid_min, gp[hook(4, 0)].grid_delta);
  bool wrap_edges = false;

  int hash = calcGridHash(gridPos, gp[hook(4, 0)].grid_res, wrap_edges);

  cli[hook(6, index)].xyz = gridPos.xyz;
  cli[hook(6, index)].w = hash;

  hash = hash > gp[hook(4, 0)].nb_cells ? gp[hook(4, 0)].nb_cells : hash;
  hash = hash < 0 ? gp[hook(4, 0)].nb_cells : hash;
  sort_hashes[hook(2, index)] = (unsigned int)hash;

  sort_indexes[hook(3, index)] = index;
}