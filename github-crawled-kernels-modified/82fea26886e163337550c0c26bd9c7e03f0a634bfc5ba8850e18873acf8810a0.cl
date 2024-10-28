//{"accum":2,"globalQueueIndex":11,"invRho":4,"numRho":3,"pointsCount":1,"pointsList":1,"pointsLists":0,"queue":10,"queueIndex":8,"queue[tid.y]":9,"src":0,"theta":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0x10 | 4;
kernel __attribute__((reqd_work_group_size(32, 4, 1))) void buildPointsList(read_only image2d_t src, global unsigned int* pointsList, global unsigned int* pointsCount) {
  int2 gid = {get_global_id(0), get_global_id(1)};
  if (any(gid >= get_image_dim(src)))
    return;

  local unsigned int queue[4][32];
  local unsigned int queueIndex[4];
  local unsigned int globalQueueIndex[4];

  int2 tid = {get_local_id(0), get_local_id(1)};

  if (tid.x == 0)
    queueIndex[hook(8, tid.y)] = 0;
  barrier(0x01);

  float pix = read_imagef(src, sampler, gid).x;

  if (pix > 0.0f) {
    unsigned int coord = (gid.x << 16) | gid.y;

    int idx = atomic_inc(&queueIndex[hook(8, tid.y)]);

    queue[hook(10, tid.y)][hook(9, idx)] = coord;
  }
  barrier(0x01);

  if (tid.x == 0 && tid.y == 0) {
    unsigned int totalSize = 0;
    for (int i = 0; i < 4; ++i) {
      globalQueueIndex[hook(11, i)] = totalSize;
      totalSize += queueIndex[hook(8, i)];
    }

    unsigned int globalOffset = atomic_add(pointsCount, totalSize);
    for (int i = 0; i < 4; ++i)
      globalQueueIndex[hook(11, i)] += globalOffset;
  }
  barrier(0x01);

  const unsigned int qsize = queueIndex[hook(8, tid.y)];
  unsigned int gidx = globalQueueIndex[hook(11, tid.y)] + tid.x;
  if (tid.x < qsize)
    pointsList[hook(1, gidx)] = queue[hook(10, tid.y)][hook(9, tid.x)];
}

kernel __attribute__((reqd_work_group_size(32, 4, 1))) void buildPointsList_x16(read_only image2d_t src, global unsigned int* pointsList, global unsigned int* pointsCount) {
  int2 gid = {get_global_id(0), get_global_id(1)};
  int2 tid = {get_local_id(0), get_local_id(1)};
  int2 size = get_image_dim(src);

  local unsigned int queue[4][32 * 16];
  local unsigned int queueIndex[4];
  local unsigned int globalQueueIndex[4];

  if (tid.x == 0)
    queueIndex[hook(8, tid.y)] = 0;
  barrier(0x01);

  if (gid.y < size.y) {
    int workGroupStride = get_local_size(0) * 16;
    int x = get_group_id(0) * workGroupStride + tid.x;
    const int range = min(x + workGroupStride, size.x);
    for (; x < range; x += get_local_size(0)) {
      int2 c = (int2)(x, gid.y);
      float pix = read_imagef(src, sampler, c).x;

      if (pix > 0.0f) {
        unsigned int coord = (c.x << 16) | c.y;

        int idx = atomic_inc(&queueIndex[hook(8, tid.y)]);

        queue[hook(10, tid.y)][hook(9, idx)] = coord;
      }
    }
  }
  barrier(0x01);

  if (tid.x == 0 && tid.y == 0) {
    unsigned int totalSize = 0;
    for (int i = 0; i < 4; ++i) {
      globalQueueIndex[hook(11, i)] = totalSize;
      totalSize += queueIndex[hook(8, i)];
    }

    unsigned int globalOffset = atomic_add(pointsCount, totalSize);
    for (int i = 0; i < 4; ++i)
      globalQueueIndex[hook(11, i)] += globalOffset;
  }
  barrier(0x01);

  const unsigned int qsize = queueIndex[hook(8, tid.y)];
  unsigned int gidx = globalQueueIndex[hook(11, tid.y)] + tid.x;
  for (unsigned int i = tid.x; i < qsize; i += get_local_size(0), gidx += get_local_size(0))
    pointsList[hook(1, gidx)] = queue[hook(10, tid.y)][hook(9, i)];
}

kernel void accumLines(global unsigned int* pointsLists, global unsigned int* pointsCount, global int* accum, const int numRho, float invRho, float theta) {
  int x = get_group_id(0);
  float angle = x * theta;

  float cosVal;
  float sinVal = sincos(angle, &cosVal);
  sinVal *= invRho;
  cosVal *= invRho;

  int shift = (numRho - 1) / 2;
  unsigned int nCount = pointsCount[hook(1, 0)];

  for (unsigned int i = get_local_id(0); i < nCount; i += get_local_size(0)) {
    unsigned int coords = pointsLists[hook(0, i)];
    unsigned int x0 = coords >> 16;
    unsigned int y0 = coords & 0xFFFF;

    int rho = convert_int_rte(x0 * cosVal + y0 * sinVal) + shift;
    atomic_inc(&accum[hook(2, mad24(x, numRho, rho))]);
  }
}