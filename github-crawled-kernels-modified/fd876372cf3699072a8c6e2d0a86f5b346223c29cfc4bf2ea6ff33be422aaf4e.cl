//{"result":1,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
constant sampler_t sampler2 = 0 | 4 | 0x10;
kernel void dilate(read_only image3d_t volume, global uchar* result) {
  int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  if (read_imageui(volume, sampler, pos).x == 1) {
    const int N = 2;
    for (int a = -N; a <= N; ++a) {
      for (int b = -N; b <= N; ++b) {
        for (int c = -N; c <= N; ++c) {
          int4 nPos = pos + (int4)(a, b, c, 0);

          if (nPos.x >= 0 && nPos.y >= 0 && nPos.z >= 0 && nPos.x < get_global_size(0) && nPos.y < get_global_size(1) && nPos.z < get_global_size(2))
            result[hook(1, nPos.x + nPos.y * get_global_size(0) + nPos.z * get_global_size(0) * get_global_size(1))] = 1;
        }
      }
    }
  }
}