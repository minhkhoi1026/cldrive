//{"dt":3,"num":4,"p":0,"q":1,"v":2}
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

kernel void predictPosition(global float2* p, global float2* q, global float2* v, float dt, unsigned int num) {
  size_t tid = get_global_id(0);
  if (tid >= num)
    return;

  float2 vel = v[hook(2, tid)];
  float2 pos = p[hook(0, tid)];

  vel.y += dt * -9.81;

  q[hook(1, tid)] = pos + dt * vel;
  v[hook(2, tid)] = vel;
}