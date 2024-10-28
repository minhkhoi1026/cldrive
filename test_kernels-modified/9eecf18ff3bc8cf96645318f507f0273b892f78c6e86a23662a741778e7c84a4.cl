//{"inv_dt":4,"np":2,"num":5,"nv":3,"q":0,"v":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct Domain {
  float2 offset;
  uint2 size;
  float dx;
  float pad;
};

inline int2 getGridPos(float2 p, struct Domain domain) {
  float x = (p.x - domain.offset.x) / domain.dx;
  float y = (p.y - domain.offset.y) / domain.dx;
  return (int2)((int)x, (int)y);
}

inline unsigned int getGridHash(int2 pos, uint2 gridSize) {
  return ((unsigned int)pos.x & (gridSize.x - 1)) + ((unsigned int)pos.y & (gridSize.y - 1)) * gridSize.x;
}

kernel void finalAdvect(global float2* q,

                        global float2* v, global float2* np, global float2* nv, float inv_dt, unsigned int num) {
  size_t tid = get_global_id(0);
  if (tid >= num)
    return;

  float2 xstar = q[hook(0, tid)];
  np[hook(2, tid)] = xstar;
  nv[hook(3, tid)] = v[hook(1, tid)];
}