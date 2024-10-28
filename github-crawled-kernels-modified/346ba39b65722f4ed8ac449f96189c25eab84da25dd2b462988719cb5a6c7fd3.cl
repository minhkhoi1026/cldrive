//{"offset2D":2,"readLevel":0,"writeLevel":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int2 offset2D[4] = {{0, 0}, {0, 1}, {1, 0}, {1, 1}};

constant int4 offset3D[8] = {{0, 0, 0, 0}, {1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {1, 0, 1, 0}, {1, 1, 1, 0}, {0, 1, 1, 0}, {1, 1, 0, 0}};

constant sampler_t sampler = 0 | 0 | 0x10;

kernel void createMinMaxImage2DLevel(read_only image2d_t readLevel, write_only image2d_t writeLevel) {
  const int2 pos = {get_global_id(0), get_global_id(1)};
  const int2 readPos = pos * 2;

  int4 result = {32767, (-32768), 0, 0};
  int4 temp;
  temp = read_imagei(readLevel, sampler, readPos + offset2D[hook(2, 0)]);
  result.x = min(result.x, temp.x);
  result.y = max(result.y, temp.y);
  temp = read_imagei(readLevel, sampler, readPos + offset2D[hook(2, 1)]);
  result.x = min(result.x, temp.x);
  result.y = max(result.y, temp.y);
  temp = read_imagei(readLevel, sampler, readPos + offset2D[hook(2, 2)]);
  result.x = min(result.x, temp.x);
  result.y = max(result.y, temp.y);
  temp = read_imagei(readLevel, sampler, readPos + offset2D[hook(2, 3)]);
  result.x = min(result.x, temp.x);
  result.y = max(result.y, temp.y);

  write_imagei(writeLevel, pos, result);
}