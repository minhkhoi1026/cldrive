//{"accum":0,"accumImage":3,"accumPitch":1,"globalQueueIndex":10,"pointsCount":2,"pointsList":1,"queue":9,"queueIndex":7,"queue[tid.y]":8,"scale":2,"src":0}
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
    queueIndex[hook(7, tid.y)] = 0;
  barrier(0x01);

  float pix = read_imagef(src, sampler, gid).x;

  if (pix > 0.0f) {
    unsigned int coord = (gid.x << 16) | gid.y;

    int idx = atomic_inc(&queueIndex[hook(7, tid.y)]);

    queue[hook(9, tid.y)][hook(8, idx)] = coord;
  }
  barrier(0x01);

  if (tid.x == 0 && tid.y == 0) {
    unsigned int totalSize = 0;
    for (int i = 0; i < 4; ++i) {
      globalQueueIndex[hook(10, i)] = totalSize;
      totalSize += queueIndex[hook(7, i)];
    }

    unsigned int globalOffset = atomic_add(pointsCount, totalSize);
    for (int i = 0; i < 4; ++i)
      globalQueueIndex[hook(10, i)] += globalOffset;
  }
  barrier(0x01);

  const unsigned int qsize = queueIndex[hook(7, tid.y)];
  unsigned int gidx = globalQueueIndex[hook(10, tid.y)] + tid.x;
  if (tid.x < qsize)
    pointsList[hook(1, gidx)] = queue[hook(9, tid.y)][hook(8, tid.x)];
}

kernel __attribute__((reqd_work_group_size(32, 4, 1))) void buildPointsList_x16(read_only image2d_t src, global unsigned int* pointsList, global unsigned int* pointsCount) {
  int2 gid = {get_global_id(0), get_global_id(1)};
  int2 tid = {get_local_id(0), get_local_id(1)};
  int2 size = get_image_dim(src);

  local unsigned int queue[4][32 * 16];
  local unsigned int queueIndex[4];
  local unsigned int globalQueueIndex[4];

  if (tid.x == 0)
    queueIndex[hook(7, tid.y)] = 0;
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

        int idx = atomic_inc(&queueIndex[hook(7, tid.y)]);

        queue[hook(9, tid.y)][hook(8, idx)] = coord;
      }
    }
  }
  barrier(0x01);

  if (tid.x == 0 && tid.y == 0) {
    unsigned int totalSize = 0;
    for (int i = 0; i < 4; ++i) {
      globalQueueIndex[hook(10, i)] = totalSize;
      totalSize += queueIndex[hook(7, i)];
    }

    unsigned int globalOffset = atomic_add(pointsCount, totalSize);
    for (int i = 0; i < 4; ++i)
      globalQueueIndex[hook(10, i)] += globalOffset;
  }
  barrier(0x01);

  const unsigned int qsize = queueIndex[hook(7, tid.y)];
  unsigned int gidx = globalQueueIndex[hook(10, tid.y)] + tid.x;
  for (unsigned int i = tid.x; i < qsize; i += get_local_size(0), gidx += get_local_size(0))
    pointsList[hook(1, gidx)] = queue[hook(9, tid.y)][hook(8, i)];
}

__attribute__((always_inline)) int read_buffer_clamp(global int* src, int width, int height, int pitch, int x, int y) {
  if (y < 0 || y >= height - 1)
    return 0;
  if (x < 0 || x >= width - 1)
    return 0;
  return src[hook(0, mad24(y, pitch, x))];
}
kernel void accumToImage(global int* accum, int accumPitch, float scale, write_only image2d_t accumImage) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  if (y >= get_image_width(accumImage) || x >= get_image_height(accumImage))
    return;

  int v = accum[hook(0, mad24(y, accumPitch, x))];
  float fv = min(1.0f, (float)v / scale);
  int2 coords = (int2)(y, x);

  write_imagef(accumImage, coords, (float4)(fv));
}