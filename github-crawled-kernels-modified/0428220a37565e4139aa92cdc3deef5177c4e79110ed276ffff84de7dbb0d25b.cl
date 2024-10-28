//{"class0offset":2,"class1offset":3,"gInput":0,"gInputImage":4,"outputArr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sampleZeroPaddedFloat(const global float* gInputImage, int offset, int x, int y, int width, int height) {
  if (x < 0 || x >= width || y < 0 || y >= height)
    return 0.0f;
  return gInputImage[hook(4, offset + (y * width + x))];
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
  return gInputImage[hook(4, offset + (y * width + x))];
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
  return gInputImage[hook(4, z * width * height + y * width + x)];
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
kernel void toLabelImage2ClassesBin(const global float* gInput, global float* outputArr, float class0offset, float class1offset) {
  int index = get_global_id(1) * get_global_size(0) + get_global_id(0);
  int widthheight = get_global_size(0) * get_global_size(1);
  float prob0 = gInput[hook(0, index)] + class0offset;
  float prob1 = gInput[hook(0, widthheight + index)] + class1offset;
  if (prob1 > prob0)
    outputArr[hook(1, index)] = 1.0f;
  else
    outputArr[hook(1, index)] = 0.0f;
}