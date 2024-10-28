//{"cellEnd":2,"cellStart":1,"im":8,"im2":13,"localHash":3,"num":4,"p":5,"p2":10,"ph":9,"ph2":14,"q":6,"q2":11,"sortArray":0,"v":7,"v2":12}
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

kernel void calcCellBoundsAndReorder(global uint2* sortArray, global unsigned int* cellStart, global unsigned int* cellEnd, local unsigned int* localHash, unsigned int num, global float2* p, global float2* q, global float2* v, global float* im, global unsigned int* ph, global float2* p2, global float2* q2, global float2* v2, global float* im2, global unsigned int* ph2) {
  const unsigned int tid = get_global_id(0);
  const unsigned int loc = get_local_id(0);
  unsigned int hash0;

  if (tid < num) {
    hash0 = sortArray[hook(0, tid)].x;

    localHash[hook(3, loc + 1)] = hash0;

    if (tid > 0 && loc == 0)
      localHash[hook(3, 0)] = sortArray[hook(0, tid - 1)].x;
  }

  barrier(0x01);

  if (tid < num) {
    if (tid == 0) {
      cellStart[hook(1, hash0)] = 0;
    } else {
      if (hash0 != localHash[hook(3, loc)])
        cellEnd[hook(2, localHash[lhook(3, loc))] = cellStart[hook(1, hash0)] = tid;
    };

    if (tid == num - 1)
      cellEnd[hook(2, hash0)] = num;

    unsigned int sortedIndex = sortArray[hook(0, tid)].y;

    p2[hook(10, tid)] = p[hook(5, sortedIndex)];
    q2[hook(11, tid)] = q[hook(6, sortedIndex)];
    v2[hook(12, tid)] = v[hook(7, sortedIndex)];
    im2[hook(13, tid)] = im[hook(8, sortedIndex)];
    ph2[hook(14, tid)] = ph[hook(9, sortedIndex)];
  }
}