//{"distance":1,"input":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
kernel void initialize(read_only image3d_t input, global short* distance) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  unsigned int value = read_imageui(input, sampler, pos).x;
  if (value == 0) {
    distance[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = 0;

  } else {
    bool atBorder = false;
    for (int a = -1; a <= 1; ++a) {
      for (int b = -1; b <= 1; ++b) {
        for (int c = -1; c <= 1; ++c) {
          int4 nPos = (int4)(a, b, c, 0) + pos;
          unsigned int value2 = read_imageui(input, sampler, nPos).x;
          if (value2 == 0) {
            atBorder = true;
          }
        }
      }
    }
    if (atBorder) {
      distance[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = -1;

    } else {
      distance[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = -1;
    }
  }
}