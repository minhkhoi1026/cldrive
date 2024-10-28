//{"readHistoPyramid":0,"writeHistoPyramid":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t interpolationSampler = 0 | 2 | 0x20;
constant sampler_t hpSampler = 0 | 4 | 0x10;
constant int4 cubeOffsets2D[4] = {
    {0, 0, 0, 0},
    {0, 1, 0, 0},
    {1, 0, 0, 0},
    {1, 1, 0, 0},
};

constant int4 cubeOffsets[8] = {
    {0, 0, 0, 0}, {1, 0, 0, 0}, {0, 0, 1, 0}, {1, 0, 1, 0}, {0, 1, 0, 0}, {1, 1, 0, 0}, {0, 1, 1, 0}, {1, 1, 1, 0},
};

kernel void constructHPLevel2D(read_only image2d_t readHistoPyramid, write_only image2d_t writeHistoPyramid) {
  int2 writePos = {get_global_id(0), get_global_id(1)};
  int2 readPos = writePos * 2;
  int writeValue = read_imagei(readHistoPyramid, hpSampler, readPos).x + read_imagei(readHistoPyramid, hpSampler, readPos + (int2)(1, 0)).x + read_imagei(readHistoPyramid, hpSampler, readPos + (int2)(0, 1)).x + read_imagei(readHistoPyramid, hpSampler, readPos + (int2)(1, 1)).x;

  write_imagei(writeHistoPyramid, writePos, writeValue);
}