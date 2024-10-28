//{"avg":6,"first":7,"gHeight":4,"gInputImage":8,"gWidth":3,"gidOfLastValidElement":5,"lsum":2,"sumInput":0,"sumResults":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sampleZeroPaddedFloat(const global float* gInputImage, int offset, int x, int y, int width, int height) {
  if (x < 0 || x >= width || y < 0 || y >= height)
    return 0.0f;
  return gInputImage[hook(8, offset + (y * width + x))];
}
float sampleRepPaddedFloat(const global float* gInputImage, int offset, int x, int y, int width, int height) {
  if (x < 0)
    x = 0;
  if (x >= width)
    x = width - 1;
  if (y < 0)
    y = 0;
  if (y >= height)
    y = height - 1;
  return gInputImage[hook(8, offset + (y * width + x))];
}
float getClampedFloat3d(const global float* gInputImage, int x, int y, int z, int width, int height, int depth) {
  if (x < 0)
    x = 0;
  if (x >= width)
    x = width - 1;
  if (y < 0)
    y = 0;
  if (y >= height)
    y = height - 1;
  if (z < 0)
    z = 0;
  if (z >= depth)
    z = depth - 1;
  return gInputImage[hook(8, z * width * height + y * width + x)];
}
int mapToRoI(int index, int width, int widthRoI, int height, int heightRoI, int depth, int depthRoI) {
  int z = index % depthRoI;
  int x = (index / depthRoI) % widthRoI;
  int y = ((index / depthRoI) / widthRoI);
  return z * width * height + y * width + x;
}

int mapToDepthMajor(int index, int width, int height, int depth) {
  int z = index % depth;
  int x = (index / depth) % width;
  int y = ((index / depth) / width);
  return z * width * height + y * width + x;
}
kernel void getSumDev(global float* sumInput, global float* sumResults, local float* lsum, int gWidth, int gHeight, int gidOfLastValidElement, float avg, int first) {
  int gx = (int)get_global_id(0);
  int gy = (int)get_global_id(1);
  int gz = (int)get_global_id(2);
  int gid = mad24(gz, gHeight * gWidth, mad24(gy, gWidth, gx));

  int lid = mad24((int)get_local_id(1), (int)get_local_size(0), (int)get_local_id(0));

  int nActiveThreads = (int)get_local_size(0) * (int)get_local_size(1);
  int halfPoint = 0;

  lsum[hook(2, lid)] = 0.0f;
  gidOfLastValidElement = gidOfLastValidElement + ((int)get_global_id(2) * (int)get_global_size(0) * (int)get_global_size(1));

  if (!(gx >= gWidth || gy >= gHeight || gid > gidOfLastValidElement)) {
    if (first == 1) {
      float dif = sumInput[hook(0, gid)] - avg;
      lsum[hook(2, lid)] = dif * dif;
    } else {
      lsum[hook(2, lid)] = sumInput[hook(0, gid)];
    }
  }

  barrier(0x01);

  while (nActiveThreads > 1) {
    halfPoint = (nActiveThreads >> 1);

    if (lid < halfPoint) {
      lsum[hook(2, lid)] += lsum[hook(2, lid + halfPoint)];
    }

    barrier(0x01);

    nActiveThreads = halfPoint;
  }

  if (lid == 0) {
    gid = mad24((int)get_group_id(2), (int)(get_num_groups(0) * get_num_groups(1)), mad24((int)get_group_id(1), (int)get_num_groups(0), (int)get_group_id(0)));
    sumResults[hook(1, gid)] = lsum[hook(2, 0)];
  }
}