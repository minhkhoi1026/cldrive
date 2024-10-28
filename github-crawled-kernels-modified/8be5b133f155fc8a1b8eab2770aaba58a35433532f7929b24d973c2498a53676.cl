//{"dstYUV":1,"gausssingle":15,"imh":4,"imw":3,"pixel":7,"pixel[0]":8,"pixel[16 - 1 + 2 + 0]":11,"pixel[16 - 1 + 2 + 1]":12,"pixel[16 - 1 + 2 + 2]":13,"pixel[1]":9,"pixel[2]":10,"pixel[localX + 2]":6,"pixel[localX + i]":14,"sigma_r":2,"srcYUV":0,"vertical_offset":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float gausssingle[25] = {0.6411f, 0.7574f, 0.8007f, 0.7574f, 0.6411f, 0.7574f, 0.8948f, 0.9459f, 0.8948f, 0.7574f, 0.8007f, 0.9460f, 1.0000f, 0.9460f, 0.8007f, 0.7574f, 0.8948f, 0.9459f, 0.8948f, 0.7574f, 0.6411f, 0.7574f, 0.8007f, 0.7574f, 0.6411f};

kernel void kernel_bilateral_nv12(read_only image2d_t srcYUV, write_only image2d_t dstYUV, float sigma_r, unsigned int imw, unsigned int imh, unsigned int vertical_offset) {
  int x = get_global_id(1);
  int y = get_global_id(0);
  int localX = get_local_id(1);
  int localY = get_local_id(0);

  float normF = 0.0f;
  float H = 0.0f;
  float delta = 0.0f;
  int i = 0, j = 0;
  sampler_t sampler = 0 | 0 | 0x10;
  sigma_r = 2 * pown(sigma_r, 2);

  float4 line;
  line.x = 0.0f;
  line.y = 0.0f;
  line.z = 0.0f;
  line.w = 1.0f;
  float4 uv_in;

  if (y % 2 == 0) {
    uv_in = read_imagef(srcYUV, sampler, (int2)(x, y / 2 + vertical_offset));
    write_imagef(dstYUV, (int2)(x, y / 2 + vertical_offset), uv_in);
  }

  local float4 pixel[16 + 4][15 + 4];
  bool interior = x > 1 && x < (imw - 3) && y > 1 && y < (imh - 3);
  if (interior) {
    pixel[hook(7, localX + 2)][hook(6, localY + 2)] = read_imagef(srcYUV, sampler, (int2)(x, y));

    if (localX == 0) {
      if (localY == 0) {
        pixel[hook(7, 0)][hook(8, 0)] = read_imagef(srcYUV, sampler, (int2)(x - 2, y - 2));
        pixel[hook(7, 0)][hook(8, 1)] = read_imagef(srcYUV, sampler, (int2)(x - 2, y - 1));
        pixel[hook(7, 0)][hook(8, 2)] = read_imagef(srcYUV, sampler, (int2)(x - 2, y));
        pixel[hook(7, 1)][hook(9, 0)] = read_imagef(srcYUV, sampler, (int2)(x - 1, y - 2));
        pixel[hook(7, 1)][hook(9, 1)] = read_imagef(srcYUV, sampler, (int2)(x - 1, y - 1));
        pixel[hook(7, 1)][hook(9, 2)] = read_imagef(srcYUV, sampler, (int2)(x - 1, y));
        pixel[hook(7, 2)][hook(10, 0)] = read_imagef(srcYUV, sampler, (int2)(x, y - 2));
        pixel[hook(7, 2)][hook(10, 1)] = read_imagef(srcYUV, sampler, (int2)(x, y - 1));
      } else if (localY == 15 - 1) {
        pixel[hook(7, 0)][hook(8, 15 - 1 + 2)] = read_imagef(srcYUV, sampler, (int2)(x - 2, y));
        pixel[hook(7, 0)][hook(8, 15 + 2)] = read_imagef(srcYUV, sampler, (int2)(x - 2, y + 1));
        pixel[hook(7, 0)][hook(8, 15 + 1 + 2)] = read_imagef(srcYUV, sampler, (int2)(x - 2, y + 2));
        pixel[hook(7, 1)][hook(9, 15 - 1 + 2)] = read_imagef(srcYUV, sampler, (int2)(x - 1, y));
        pixel[hook(7, 1)][hook(9, 15 + 2)] = read_imagef(srcYUV, sampler, (int2)(x - 1, y + 1));
        pixel[hook(7, 1)][hook(9, 15 + 1 + 2)] = read_imagef(srcYUV, sampler, (int2)(x - 1, y + 2));
        pixel[hook(7, 2)][hook(10, 15 + 2)] = read_imagef(srcYUV, sampler, (int2)(x, y + 1));
        pixel[hook(7, 2)][hook(10, 15 + 1 + 2)] = read_imagef(srcYUV, sampler, (int2)(x, y + 2));
      } else {
        pixel[hook(7, 0)][hook(8, localY + 2)] = read_imagef(srcYUV, sampler, (int2)(x - 2, y));
        pixel[hook(7, 1)][hook(9, localY + 2)] = read_imagef(srcYUV, sampler, (int2)(x - 1, y));
      }
    } else if (localX == 16 - 1) {
      if (localY == 0) {
        pixel[hook(7, 16 - 1 + 2 + 0)][hook(11, 0)] = read_imagef(srcYUV, sampler, (int2)(x, y - 2));
        pixel[hook(7, 16 - 1 + 2 + 0)][hook(11, 1)] = read_imagef(srcYUV, sampler, (int2)(x, y - 1));

        pixel[hook(7, 16 - 1 + 2 + 1)][hook(12, 0)] = read_imagef(srcYUV, sampler, (int2)(x + 1, y - 2));
        pixel[hook(7, 16 - 1 + 2 + 1)][hook(12, 1)] = read_imagef(srcYUV, sampler, (int2)(x + 1, y - 1));
        pixel[hook(7, 16 - 1 + 2 + 1)][hook(12, 2)] = read_imagef(srcYUV, sampler, (int2)(x + 1, y));
        pixel[hook(7, 16 - 1 + 2 + 2)][hook(13, 0)] = read_imagef(srcYUV, sampler, (int2)(x + 2, y - 2));
        pixel[hook(7, 16 - 1 + 2 + 2)][hook(13, 1)] = read_imagef(srcYUV, sampler, (int2)(x + 2, y - 1));
        pixel[hook(7, 16 - 1 + 2 + 2)][hook(13, 2)] = read_imagef(srcYUV, sampler, (int2)(x + 2, y));
      } else if (localY == 15 - 1) {
        pixel[hook(7, 16 - 1 + 2 + 0)][hook(11, 15 - 1 + 2 + 1)] = read_imagef(srcYUV, sampler, (int2)(x, y + 1));
        pixel[hook(7, 16 - 1 + 2 + 0)][hook(11, 15 - 1 + 2 + 2)] = read_imagef(srcYUV, sampler, (int2)(x, y + 2));
        pixel[hook(7, 16 - 1 + 2 + 1)][hook(12, 15 - 1 + 2 + 0)] = read_imagef(srcYUV, sampler, (int2)(x + 1, y));
        pixel[hook(7, 16 - 1 + 2 + 1)][hook(12, 15 - 1 + 2 + 1)] = read_imagef(srcYUV, sampler, (int2)(x + 1, y + 1));
        pixel[hook(7, 16 - 1 + 2 + 1)][hook(12, 15 - 1 + 2 + 2)] = read_imagef(srcYUV, sampler, (int2)(x + 1, y + 2));
        pixel[hook(7, 16 - 1 + 2 + 2)][hook(13, 15 - 1 + 2 + 0)] = read_imagef(srcYUV, sampler, (int2)(x + 2, y));
        pixel[hook(7, 16 - 1 + 2 + 2)][hook(13, 15 - 1 + 2 + 1)] = read_imagef(srcYUV, sampler, (int2)(x + 2, y + 1));
        pixel[hook(7, 16 - 1 + 2 + 2)][hook(13, 15 - 1 + 2 + 2)] = read_imagef(srcYUV, sampler, (int2)(x + 2, y + 2));
      } else {
        pixel[hook(7, 16 - 1 + 2 + 1)][hook(12, localY + 2)] = read_imagef(srcYUV, sampler, (int2)(x + 1, y));
        pixel[hook(7, 16 - 1 + 2 + 2)][hook(13, localY + 2)] = read_imagef(srcYUV, sampler, (int2)(x + 2, y));
      }
    } else if (localY == 0) {
      pixel[hook(7, localX + 2)][hook(6, 0)] = read_imagef(srcYUV, sampler, (int2)(x, y - 2));
      pixel[hook(7, localX + 2)][hook(6, 1)] = read_imagef(srcYUV, sampler, (int2)(x, y - 1));
    } else if (localY == 15 - 1) {
      pixel[hook(7, localX + 2)][hook(6, 15 - 1 + 2 + 1)] = read_imagef(srcYUV, sampler, (int2)(x, y + 1));
      pixel[hook(7, localX + 2)][hook(6, 15 - 1 + 2 + 2)] = read_imagef(srcYUV, sampler, (int2)(x, y + 2));
    }
  } else {
    line = read_imagef(srcYUV, sampler, (int2)(x, y));
  }

  barrier(0x01);
  if (interior) {
    for (i = 0; i < 5; i++) {
      for (j = 0; j < 5; j++) {
        delta = pown(pixel[hook(7, localX + i)][hook(14, localY + j)].x - pixel[hook(7, localX + 2)][hook(6, localY + 2)].x, 2);
        H = (exp(-(delta / sigma_r))) * gausssingle[hook(15, i * 5 + j)];
        normF += H;
        line.x += pixel[hook(7, localX + i)][hook(14, localY + j)].x * H;
      }
    }

    line.x = line.x / normF;
  }

  write_imagef(dstYUV, (int2)(x, y), line);
}