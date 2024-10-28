//{"X":4,"buffer":0,"length":3,"maxScratch":2,"minScratch":1,"result":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int2 offset2D[4] = {{0, 0}, {0, 1}, {1, 0}, {1, 1}};

constant int4 offset3D[8] = {{0, 0, 0, 0}, {1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {1, 0, 1, 0}, {1, 1, 1, 0}, {0, 1, 1, 0}, {1, 1, 0, 0}};

constant sampler_t sampler = 0 | 0 | 0x10;

kernel void reduce(global short* buffer, local short* minScratch, local short* maxScratch, private int length, private int X, global short* result) {
  int global_index = get_global_id(0) * X;
  short minAccumulator = 32767;
  short maxAccumulator = (-32768);

  for (int i = 0; i < X && global_index < length; i++) {
    float element = buffer[hook(0, global_index)];
    minAccumulator = (minAccumulator < element) ? minAccumulator : element;
    maxAccumulator = (maxAccumulator > element) ? maxAccumulator : element;
    global_index += 1;
  }

  int local_index = get_local_id(0);
  minScratch[hook(1, local_index)] = minAccumulator;
  maxScratch[hook(2, local_index)] = maxAccumulator;
  barrier(0x01);
  for (int offset = get_local_size(0) / 2; offset > 0; offset = offset / 2) {
    if (local_index < offset) {
      short other = minScratch[hook(1, local_index + offset)];
      short mine = minScratch[hook(1, local_index)];
      minScratch[hook(1, local_index)] = (mine < other) ? mine : other;
      other = maxScratch[hook(2, local_index + offset)];
      mine = maxScratch[hook(2, local_index)];
      maxScratch[hook(2, local_index)] = (mine > other) ? mine : other;
    }
    barrier(0x01);
  }
  if (local_index == 0) {
    result[hook(5, get_group_id(0) * 2)] = minScratch[hook(1, 0)];
    result[hook(5, get_group_id(0) * 2 + 1)] = maxScratch[hook(2, 0)];
  }
}