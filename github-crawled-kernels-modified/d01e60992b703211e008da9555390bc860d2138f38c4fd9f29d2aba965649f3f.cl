//{"readHistoPyramid":1,"squareOffsets":2,"writeHistoPyramid":0}
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

kernel void constructHPLevel2D(write_only image2d_t writeHistoPyramid, read_only image2d_t readHistoPyramid) {
  const int2 coord = {get_global_id(0), get_global_id(1)};
  const int2 readPos = coord * 2;
  float writeValue = read_imagef(readHistoPyramid, sampler, readPos).x + read_imagef(readHistoPyramid, sampler, readPos + squareOffsets[hook(2, 1)]).x + read_imagef(readHistoPyramid, sampler, readPos + squareOffsets[hook(2, 2)]).x + read_imagef(readHistoPyramid, sampler, readPos + squareOffsets[hook(2, 3)]).x;
  write_imagef(writeHistoPyramid, coord, writeValue);
}