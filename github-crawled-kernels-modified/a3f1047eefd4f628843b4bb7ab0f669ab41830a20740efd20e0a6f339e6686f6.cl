//{"cubeOffsets":5,"histoPyramid":0,"isolevel":4,"nrOfTriangles":6,"rawData":1,"res":2,"slices":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant int4 cubeOffsets[8] = {
    {0, 0, 0, 0}, {1, 0, 0, 0}, {0, 0, 1, 0}, {1, 0, 1, 0}, {0, 1, 0, 0}, {1, 1, 0, 0}, {0, 1, 1, 0}, {1, 1, 1, 0},
};
constant int2 squareOffsets[4] = {{0, 0}, {1, 0}, {0, 1}, {1, 1}};
int2 map3Dto2D(int4 coord, unsigned int res, unsigned int slices) {
  const int yoffset = coord.z / slices;
  const int xoffset = coord.z % slices;

  int2 pos = {xoffset * res, yoffset * res};
  pos += (int2)(coord.x, coord.y);
  return pos;
}

int2 map3Dto2DClamp(int4 float4, int4 offset, unsigned int res, unsigned int slices) {
  int4 coord = float4 + offset;
  if (coord.z < 0 || coord.z > res - 1)
    coord.z -= offset.z;
  const int yoffset = coord.z / slices;
  const int xoffset = coord.z % slices;

  int2 pos = {xoffset * res, yoffset * res};
  pos += (int2)(coord.x, coord.y);

  int z = (pos.y / res) * slices + (pos.x / res);

  if (z != coord.z)
    return map3Dto2D(float4, res, slices);
  return pos;
}

int4 map2Dto3D(int2 coord, unsigned int res, unsigned int slices) {
  const int z = (coord.y / res) * slices + (coord.x / res);
  return (int4)(coord.x % res, coord.y % res, z, 0);
}

constant uchar nrOfTriangles[256] = {0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 2, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 3, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 3, 2, 3, 3, 2, 3, 4, 4, 3, 3, 4, 4, 3, 4, 5, 5, 2, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 3, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 4, 2, 3, 3, 4, 3, 4, 2, 3, 3, 4, 4, 5, 4, 5, 3, 2, 3, 4, 4, 3, 4, 5, 3, 2, 4, 5, 5, 4, 5, 2, 4, 1, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 3, 2, 3, 3, 4, 3, 4, 4, 5, 3, 2, 4, 3, 4, 3, 5, 2, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 4, 3, 4, 4, 3, 4, 5, 5, 4, 4, 3, 5, 2, 5, 4, 2, 1, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 2, 3, 3, 2, 3, 4, 4, 5, 4, 5, 5, 2, 4, 3, 5, 4, 3, 2, 4, 1, 3, 4, 4, 5, 4, 5, 3, 4, 4, 5, 5, 2, 3, 4, 2, 1, 2, 3, 3, 2, 3, 4, 2, 1, 3, 2, 4, 1, 2, 1, 1, 0};
kernel void classifyCubes2D(write_only image2d_t histoPyramid, read_only image2d_t rawData, private unsigned int res, private unsigned int slices, private float isolevel) {
  const int4 p4 = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  const int2 pos = map3Dto2D(p4, res, slices);

  const float first = read_imagef(rawData, sampler, pos).x;
  const uchar cubeindex = ((first > isolevel)) | ((read_imagef(rawData, sampler, map3Dto2D(p4 + cubeOffsets[hook(5, 1)], res, slices)).x > isolevel) << 1) | ((read_imagef(rawData, sampler, map3Dto2D(p4 + cubeOffsets[hook(5, 3)], res, slices)).x > isolevel) << 2) | ((read_imagef(rawData, sampler, map3Dto2D(p4 + cubeOffsets[hook(5, 2)], res, slices)).x > isolevel) << 3) | ((read_imagef(rawData, sampler, map3Dto2D(p4 + cubeOffsets[hook(5, 4)], res, slices)).x > isolevel) << 4) | ((read_imagef(rawData, sampler, map3Dto2D(p4 + cubeOffsets[hook(5, 5)], res, slices)).x > isolevel) << 5) | ((read_imagef(rawData, sampler, map3Dto2D(p4 + cubeOffsets[hook(5, 7)], res, slices)).x > isolevel) << 6) | ((read_imagef(rawData, sampler, map3Dto2D(p4 + cubeOffsets[hook(5, 6)], res, slices)).x > isolevel) << 7);

  write_imagef(histoPyramid, pos, (float4)((float)nrOfTriangles[hook(6, cubeindex)], (float)cubeindex, first, 1.0f));
}