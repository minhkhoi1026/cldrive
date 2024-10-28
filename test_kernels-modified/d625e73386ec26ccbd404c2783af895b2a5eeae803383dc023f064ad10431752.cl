//{"cellEnd":3,"cellStart":2,"count":5,"d":1,"domain":7,"num":8,"q":0,"radius":6,"weight":4}
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

kernel void collide(global float2* q, global float2* d, global unsigned int* cellStart, global unsigned int* cellEnd, global float* weight, global unsigned int* count, float radius, struct Domain domain, unsigned int num) {
  unsigned int tid = get_global_id(0);
  if (tid >= num)
    return;

  unsigned int cnt = count[hook(5, tid)];
  float2 delta = d[hook(1, tid)];
  float2 pos1 = q[hook(0, tid)];
  int2 cell = getGridPos(pos1, domain);

  float R2 = 4.0 * radius * radius;

  for (int y = -1; y <= 1; y++)
    for (int x = -1; x <= 1; x++) {
      unsigned int hash = getGridHash(cell + (int2)(x, y), domain.size);
      unsigned int start = cellStart[hook(2, hash)];

      if (start == 0xFFFFFFFFU)
        continue;

      unsigned int end = cellEnd[hook(3, hash)];
      for (unsigned int j = start; j < end; j++) {
        if (j == tid)
          continue;

        float2 int2 = q[hook(0, j)];
        float2 diff = pos1 - int2;
        float len2 = dot(diff, diff);

        if (len2 > R2)
          continue;
        float C = half_sqrt(len2) - 2.0f * radius;

        float w1 = weight[hook(4, tid)], w2 = weight[hook(4, j)];
        float cn = w1 / (w1 + w2) * C;
        float2 n = fast_normalize(diff);

        delta.x -= cn * n.x;
        delta.y -= cn * n.y;
        cnt++;
      }
    }

  d[hook(1, tid)] = delta;
  count[hook(5, tid)] = cnt;
}