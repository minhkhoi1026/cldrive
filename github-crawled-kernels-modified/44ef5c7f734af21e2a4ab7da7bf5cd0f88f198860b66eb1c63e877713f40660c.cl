//{"result":1,"size":2,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void dilate3D(read_only image3d_t volume, global uchar* result, private int size) {
  int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  if (read_imageui(volume, sampler, pos).x == 1) {
    for (int a = -size; a <= size; a++) {
      for (int b = -size; b <= size; b++) {
        for (int c = -size; c <= size; c++) {
          int4 n = (int4)(a, b, c, 0);
          if (length(convert_float4(n)) > size)
            continue;

          int4 nPos = pos + n;
          if (nPos.x >= 0 && nPos.y >= 0 && nPos.z >= 0 && nPos.x < get_global_size(0) && nPos.y < get_global_size(1) && nPos.z < get_global_size(2))
            result[hook(1, nPos.x + nPos.y * get_global_size(0) + nPos.z * get_global_size(0) * get_global_size(1))] = 1;
        }
      }
    }
  }
}