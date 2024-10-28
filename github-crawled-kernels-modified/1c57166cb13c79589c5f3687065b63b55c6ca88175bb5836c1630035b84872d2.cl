//{"result":1,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void erode(read_only image3d_t volume, global uchar* result) {
  int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  int value = read_imageui(volume, sampler, pos).x;
  if (value == 1) {
    bool keep = true;
    for (int a = -1; a < 2; a++) {
      for (int b = -1; b < 2; b++) {
        for (int c = -1; c < 2; c++) {
          keep = (read_imageui(volume, sampler, pos + (int4)(a, b, c, 0)).x == 1 && keep);
        }
      }
    }

    result[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = keep ? 1 : 0;
  } else {
    result[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = 0;
  }
}