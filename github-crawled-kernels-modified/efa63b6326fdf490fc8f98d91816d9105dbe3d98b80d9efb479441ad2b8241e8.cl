//{"result":1,"size":2,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void erode3D(read_only image3d_t volume, global uchar* result, private int size) {
  int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  int value = read_imageui(volume, sampler, pos).x;
  if (value == 1) {
    bool keep = true;
    for (int a = -size; a <= size; a++) {
      for (int b = -size; b <= size; b++) {
        for (int c = -size; c <= size; c++) {
          int4 n = (int4)(a, b, c, 0);
          if (length(convert_float4(n)) > size)
            continue;
          keep = (read_imageui(volume, sampler, pos + n).x == 1 && keep);
        }
      }
    }

    result[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = keep ? 1 : 0;
  } else {
    result[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = 0;
  }
}