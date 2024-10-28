//{"result":1,"size":2,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void erode2D(read_only image2d_t volume, write_only image2d_t result, private int size) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  int value = read_imageui(volume, sampler, pos).x;
  if (value == 1) {
    bool keep = true;
    for (int a = -size; a <= size; a++) {
      for (int b = -size; b <= size; b++) {
        int2 n = (int2)(a, b);
        if (length(convert_float2(n)) > size)
          continue;
        keep = (read_imageui(volume, sampler, pos + n).x == 1 && keep);
      }
    }
    write_imageui(result, pos, keep ? 1 : 0);
  } else {
    write_imageui(result, pos, 0);
  }
}