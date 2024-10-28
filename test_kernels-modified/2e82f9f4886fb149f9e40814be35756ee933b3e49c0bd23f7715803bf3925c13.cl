//{"domain":2,"num":3,"p":0,"sortArray":1}
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

kernel void prepareList(global float2* p, global uint2* sortArray, struct Domain domain, unsigned int num) {
  size_t tid = get_global_id(0);
  if (tid >= num)
    return;

  int2 pos = getGridPos(p[hook(0, tid)], domain);
  sortArray[hook(1, tid)] = (uint2)(getGridHash(pos, domain.size), tid);
}