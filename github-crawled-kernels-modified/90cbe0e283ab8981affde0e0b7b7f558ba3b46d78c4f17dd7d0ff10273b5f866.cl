//{"changed":2,"input":0,"neighbors":3,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
constant int4 neighbors[] = {{1, 0, 0, 0}, {-1, 0, 0, 0}, {0, 1, 0, 0}, {0, -1, 0, 0}, {0, 0, 1, 0}, {0, 0, -1, 0}};

kernel void calculateDistance(

    global short* input, global short* output,

    global char* changed) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  int value = input[hook(0, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))];

  if (value == -1) {
    int minNeighborDistance = 999999;
    for (int i = 0; i < 6; ++i) {
      int4 nPos = neighbors[hook(3, i)] + pos;

      int value2 = input[hook(0, nPos.x + nPos.y * get_global_size(0) + nPos.z * get_global_size(0) * get_global_size(1))];

      if (value2 < minNeighborDistance && value2 >= 0) {
        minNeighborDistance = value2;
      }
    }

    if (minNeighborDistance < 999999) {
      output[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = minNeighborDistance + 1;

      changed[hook(2, 0)] = 1;
    }
  } else {
    output[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = value;
  }
}