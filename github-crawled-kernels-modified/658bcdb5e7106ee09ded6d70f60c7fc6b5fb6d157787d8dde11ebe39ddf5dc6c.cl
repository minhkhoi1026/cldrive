//{"result":1,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void dilate(read_only image3d_t volume, global uchar* result) {
  int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  if (read_imageui(volume, sampler, pos).x == 1) {
    for (int a = -1; a < 2; a++) {
      for (int b = -1; b < 2; b++) {
        for (int c = -1; c < 2; c++) {
          int4 nPos = pos + (int4)(a, b, c, 0);

          if (nPos.x >= 0 && nPos.y >= 0 && nPos.z >= 0 && nPos.x < get_global_size(0) && nPos.y < get_global_size(1) && nPos.z < get_global_size(2))
            result[hook(1, nPos.x + nPos.y * get_global_size(0) + nPos.z * get_global_size(0) * get_global_size(1))] = 1;
        }
      }
    }
  }
}