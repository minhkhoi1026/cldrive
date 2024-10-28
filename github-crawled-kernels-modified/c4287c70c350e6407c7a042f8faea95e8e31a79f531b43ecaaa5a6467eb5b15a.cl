//{"d_dest":1,"d_source":0,"height":3,"s_source":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void census_kernel(global const uchar* d_source, global ulong* d_dest, int width, int height) {
  const int i = get_global_id(1);
  const int j = get_global_id(0);
  const int offset = j + i * width;

  const int rad_h = 9 / 2;
  const int rad_v = 7 / 2;

  local uchar s_source[(16 + 9) * (16 + 7)];
  const int ii = i - rad_v;
  const int jj = j - rad_h;
  if (ii >= 0 && ii < height && jj >= 0 && jj < width) {
    s_source[hook(4, get_local_id(1) * (16 + 9) + get_local_id(0))] = d_source[hook(0, ii * width + jj)];
  }

  {
    const int ii = i - rad_v;
    const int jj = j - rad_h + get_local_size(0);
    if (get_local_id(0) + get_local_size(0) < (16 + 9) && get_local_id(1) < (16 + 7)) {
      if (ii >= 0 && ii < height && jj >= 0 && jj < width) {
        s_source[hook(4, get_local_id(1) * (16 + 9) + get_local_id(0) + get_local_size(0))] = d_source[hook(0, ii * width + jj)];
      }
    }
  }

  {
    const int ii = i - rad_v + get_local_size(1);
    const int jj = j - rad_h;
    if (get_local_id(0) < (16 + 9) && get_local_id(1) + get_local_size(1) < (16 + 7)) {
      if (ii >= 0 && ii < height && jj >= 0 && jj < width) {
        s_source[hook(4, (get_local_id(1) + get_local_size(1)) * (16 + 9) + get_local_id(0))] = d_source[hook(0, ii * width + jj)];
      }
    }
  }

  {
    const int ii = i - rad_v + get_local_size(1);
    const int jj = j - rad_h + get_local_size(0);
    if (get_local_id(0) + get_local_size(0) < (16 + 9) && get_local_id(1) + get_local_size(1) < (16 + 7)) {
      if (ii >= 0 && ii < height && jj >= 0 && jj < width) {
        s_source[hook(4, (get_local_id(1) + get_local_size(1)) * (16 + 9) + get_local_id(0) + get_local_size(0))] = d_source[hook(0, ii * width + jj)];
      }
    }
  }
  barrier(0x01);

  if (rad_v <= i && i < height - rad_v && rad_h <= j && j < width - rad_h) {
    const int ii = get_local_id(1) + rad_v;
    const int jj = get_local_id(0) + rad_h;
    const int soffset = jj + ii * (16 + 9);

    const uchar c = s_source[hook(4, soffset)];
    ulong value = 0;

    unsigned int value1 = 0, value2 = 0;

    for (int y = -rad_v; y < 0; y++) {
      for (int x = -rad_h; x <= rad_h; x++) {
        uchar result = (c - s_source[hook(4, (16 + 9) * (ii + y) + jj + x)]) > 0;
        value1 <<= 1;
        value1 += result;
      }
    }

    int y = 0;
    for (int x = -rad_h; x < 0; x++) {
      uchar result = (c - s_source[hook(4, (16 + 9) * (ii + y) + jj + x)]) > 0;
      value1 <<= 1;
      value1 += result;
    }

    for (int x = 1; x <= rad_h; x++) {
      uchar result = (c - s_source[hook(4, (16 + 9) * (ii + y) + jj + x)]) > 0;
      value2 <<= 1;
      value2 += result;
    }

    for (int y = 1; y <= rad_v; y++) {
      for (int x = -rad_h; x <= rad_h; x++) {
        uchar result = (c - s_source[hook(4, (16 + 9) * (ii + y) + jj + x)]) > 0;
        value2 <<= 1;
        value2 += result;
      }
    }

    value = (ulong)value2;
    value |= (ulong)value1 << (rad_v * (2 * rad_h + 1) + rad_h);

    d_dest[hook(1, offset)] = value;
  }
}