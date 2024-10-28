//{"R":5,"count":3,"d":1,"domain":6,"invdt":4,"num":8,"omega":7,"q":0,"v":2}
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

kernel void wallCollideAndApply(global float2* q, global float2* d, global float2* v, global unsigned int* count, float invdt, float R, struct Domain domain, float omega, unsigned int num) {
  unsigned int tid = get_global_id(0);
  if (tid >= num)
    return;

  float2 p0 = q[hook(0, tid)];
  float2 pos = p0 - domain.offset - R;
  float2 delta = d[hook(1, tid)];
  int cnt = count[hook(3, tid)];
  float2 size = convert_float2(domain.size) * domain.dx - 2 * R;

  if (pos.x < 0) {
    delta.x -= pos.x;
    cnt++;
  } else if (pos.x > size.x) {
    delta.x += size.x - pos.x;
    cnt++;
  }
  if (pos.y < 0) {
    delta.y -= pos.y;
    cnt++;
  } else if (pos.y > size.y) {
    delta.y += size.y - pos.y;
    cnt++;
  }

  float corr = (cnt == 0) ? 0.0f : (omega / (float)cnt);
  q[hook(0, tid)] = p0 + delta * corr;
  v[hook(2, tid)] += (invdt * corr) * delta;
}