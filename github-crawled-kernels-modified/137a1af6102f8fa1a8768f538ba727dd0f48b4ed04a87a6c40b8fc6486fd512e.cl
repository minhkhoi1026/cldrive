//{"accum":0,"globalQueueIndex":14,"lines":1,"maxLines":4,"numAngle":6,"numRho":5,"pointsCount":2,"pointsList":1,"queue":13,"queueIndex":11,"queue[tid.y]":12,"rho":7,"src":0,"theta":8,"threshold":3}
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
    queueIndex[hook(11, tid.y)] = 0;
  barrier(0x01);

  float pix = read_imagef(src, sampler, gid).x;

  if (pix > 0.0f) {
    unsigned int coord = (gid.x << 16) | gid.y;

    int idx = atomic_inc(&queueIndex[hook(11, tid.y)]);

    queue[hook(13, tid.y)][hook(12, idx)] = coord;
  }
  barrier(0x01);

  if (tid.x == 0 && tid.y == 0) {
    unsigned int totalSize = 0;
    for (int i = 0; i < 4; ++i) {
      globalQueueIndex[hook(14, i)] = totalSize;
      totalSize += queueIndex[hook(11, i)];
    }

    unsigned int globalOffset = atomic_add(pointsCount, totalSize);
    for (int i = 0; i < 4; ++i)
      globalQueueIndex[hook(14, i)] += globalOffset;
  }
  barrier(0x01);

  const unsigned int qsize = queueIndex[hook(11, tid.y)];
  unsigned int gidx = globalQueueIndex[hook(14, tid.y)] + tid.x;
  if (tid.x < qsize)
    pointsList[hook(1, gidx)] = queue[hook(13, tid.y)][hook(12, tid.x)];
}

kernel __attribute__((reqd_work_group_size(32, 4, 1))) void buildPointsList_x16(read_only image2d_t src, global unsigned int* pointsList, global unsigned int* pointsCount) {
  int2 gid = {get_global_id(0), get_global_id(1)};
  int2 tid = {get_local_id(0), get_local_id(1)};
  int2 size = get_image_dim(src);

  local unsigned int queue[4][32 * 16];
  local unsigned int queueIndex[4];
  local unsigned int globalQueueIndex[4];

  if (tid.x == 0)
    queueIndex[hook(11, tid.y)] = 0;
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

        int idx = atomic_inc(&queueIndex[hook(11, tid.y)]);

        queue[hook(13, tid.y)][hook(12, idx)] = coord;
      }
    }
  }
  barrier(0x01);

  if (tid.x == 0 && tid.y == 0) {
    unsigned int totalSize = 0;
    for (int i = 0; i < 4; ++i) {
      globalQueueIndex[hook(14, i)] = totalSize;
      totalSize += queueIndex[hook(11, i)];
    }

    unsigned int globalOffset = atomic_add(pointsCount, totalSize);
    for (int i = 0; i < 4; ++i)
      globalQueueIndex[hook(14, i)] += globalOffset;
  }
  barrier(0x01);

  const unsigned int qsize = queueIndex[hook(11, tid.y)];
  unsigned int gidx = globalQueueIndex[hook(14, tid.y)] + tid.x;
  for (unsigned int i = tid.x; i < qsize; i += get_local_size(0), gidx += get_local_size(0))
    pointsList[hook(1, gidx)] = queue[hook(13, tid.y)][hook(12, i)];
}

__attribute__((always_inline)) int read_buffer_clamp(global int* src, int width, int height, int pitch, int x, int y) {
  if (y < 0 || y >= height - 1)
    return 0;
  if (x < 0 || x >= width - 1)
    return 0;
  return src[hook(0, mad24(y, pitch, x))];
}
kernel void getLines(global int* accum, global float2* lines, volatile global int* pointsCount, const int threshold, const int maxLines, const int numRho, const int numAngle, float rho, float theta) {
  int2 gid = {get_global_id(0), get_global_id(1)};
  if (gid.x >= numRho || gid.y >= numAngle)
    return;

  const float shift = (numRho - 1) * 0.5f;

  int v = read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x, gid.y);
  if (v > threshold && v > read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x - 2, gid.y) && v > read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x - 1, gid.y) && v >= read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x + 1, gid.y) && v >= read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x + 2, gid.y) && v > read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x - 1, gid.y - 1) && v > read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x, gid.y - 1) && v > read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x + 1, gid.y - 1) && v > read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x, gid.y - 2) && v > read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x - 1, gid.y + 1) && v >= read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x, gid.y + 1) && v >= read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x + 1, gid.y + 1) && v >= read_buffer_clamp(accum, numRho, numAngle, numRho, gid.x, gid.y + 2)) {
    int idx = atomic_inc(pointsCount);
    if (idx < maxLines) {
      float r = (gid.x - shift) * rho;
      float t = gid.y * theta;
      lines[hook(1, idx)] = (float2)(r, t);
    }
  }
}