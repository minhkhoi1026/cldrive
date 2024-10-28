//{"dstRGB":1,"gausssingle":14,"imh":4,"imw":3,"pixel":6,"pixel[0]":7,"pixel[16 - 1 + 2 + 0]":10,"pixel[16 - 1 + 2 + 1]":11,"pixel[16 - 1 + 2 + 2]":12,"pixel[1]":8,"pixel[2]":9,"pixel[localX + 2]":5,"pixel[localX + i]":13,"sigma_r":2,"srcRGB":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float gausssingle[25] = {0.6411, 0.7574, 0.8007, 0.7574, 0.6411, 0.7574, 0.8948, 0.9459, 0.8948, 0.7574, 0.8007, 0.94595945, 1, 0.9459, 0.8007, 0.7574, 0.8948, 0.9459, 0.8948, 0.7574, 0.6411, 0.7574, 0.8007, 0.7574, 0.6411};

kernel void kernel_denoise(read_only image2d_t srcRGB, write_only image2d_t dstRGB, float sigma_r, unsigned int imw, unsigned int imh) {
  int x = get_global_id(1);
  int y = get_global_id(0);
  int localX = get_local_id(1);
  int localY = get_local_id(0);

  float normF = 0;
  float H = 0;
  float delta = 0;
  int i = 0, j = 0;
  sampler_t sampler = 0 | 0 | 0x10;
  sigma_r = 2 * pown(sigma_r, 2);

  float4 line;
  line.x = 0;
  line.y = 0;
  line.z = 0;
  line.w = 1.0;

  local float4 pixel[16 + 4][15 + 4];
  bool interior = x > 1 && x < (imw - 3) && y > 1 && y < (imh - 3);
  if (interior) {
    pixel[hook(6, localX + 2)][hook(5, localY + 2)] = read_imagef(srcRGB, sampler, (int2)(x, y));

    if (localX == 0) {
      if (localY == 0) {
        pixel[hook(6, 0)][hook(7, 0)] = read_imagef(srcRGB, sampler, (int2)(x - 2, y - 2));
        pixel[hook(6, 0)][hook(7, 1)] = read_imagef(srcRGB, sampler, (int2)(x - 2, y - 1));
        pixel[hook(6, 0)][hook(7, 2)] = read_imagef(srcRGB, sampler, (int2)(x - 2, y));
        pixel[hook(6, 1)][hook(8, 0)] = read_imagef(srcRGB, sampler, (int2)(x - 1, y - 2));
        pixel[hook(6, 1)][hook(8, 1)] = read_imagef(srcRGB, sampler, (int2)(x - 1, y - 1));
        pixel[hook(6, 1)][hook(8, 2)] = read_imagef(srcRGB, sampler, (int2)(x - 1, y));
        pixel[hook(6, 2)][hook(9, 0)] = read_imagef(srcRGB, sampler, (int2)(x, y - 2));
        pixel[hook(6, 2)][hook(9, 1)] = read_imagef(srcRGB, sampler, (int2)(x, y - 1));
      } else if (localY == 15 - 1) {
        pixel[hook(6, 0)][hook(7, 15 - 1 + 2)] = read_imagef(srcRGB, sampler, (int2)(x - 2, y));
        pixel[hook(6, 0)][hook(7, 15 + 2)] = read_imagef(srcRGB, sampler, (int2)(x - 2, y + 1));
        pixel[hook(6, 0)][hook(7, 15 + 1 + 2)] = read_imagef(srcRGB, sampler, (int2)(x - 2, y + 2));
        pixel[hook(6, 1)][hook(8, 15 - 1 + 2)] = read_imagef(srcRGB, sampler, (int2)(x - 1, y));
        pixel[hook(6, 1)][hook(8, 15 + 2)] = read_imagef(srcRGB, sampler, (int2)(x - 1, y + 1));
        pixel[hook(6, 1)][hook(8, 15 + 1 + 2)] = read_imagef(srcRGB, sampler, (int2)(x - 1, y + 2));
        pixel[hook(6, 2)][hook(9, 15 + 2)] = read_imagef(srcRGB, sampler, (int2)(x, y + 1));
        pixel[hook(6, 2)][hook(9, 15 + 1 + 2)] = read_imagef(srcRGB, sampler, (int2)(x, y + 2));
      } else {
        pixel[hook(6, 0)][hook(7, localY + 2)] = read_imagef(srcRGB, sampler, (int2)(x - 2, y));
        pixel[hook(6, 1)][hook(8, localY + 2)] = read_imagef(srcRGB, sampler, (int2)(x - 1, y));
      }
    } else if (localX == 16 - 1) {
      if (localY == 0) {
        pixel[hook(6, 16 - 1 + 2 + 0)][hook(10, 0)] = read_imagef(srcRGB, sampler, (int2)(x, y - 2));
        pixel[hook(6, 16 - 1 + 2 + 0)][hook(10, 1)] = read_imagef(srcRGB, sampler, (int2)(x, y - 1));

        pixel[hook(6, 16 - 1 + 2 + 1)][hook(11, 0)] = read_imagef(srcRGB, sampler, (int2)(x + 1, y - 2));
        pixel[hook(6, 16 - 1 + 2 + 1)][hook(11, 1)] = read_imagef(srcRGB, sampler, (int2)(x + 1, y - 1));
        pixel[hook(6, 16 - 1 + 2 + 1)][hook(11, 2)] = read_imagef(srcRGB, sampler, (int2)(x + 1, y));
        pixel[hook(6, 16 - 1 + 2 + 2)][hook(12, 0)] = read_imagef(srcRGB, sampler, (int2)(x + 2, y - 2));
        pixel[hook(6, 16 - 1 + 2 + 2)][hook(12, 1)] = read_imagef(srcRGB, sampler, (int2)(x + 2, y - 1));
        pixel[hook(6, 16 - 1 + 2 + 2)][hook(12, 2)] = read_imagef(srcRGB, sampler, (int2)(x + 2, y));
      } else if (localY == 15 - 1) {
        pixel[hook(6, 16 - 1 + 2 + 0)][hook(10, 15 - 1 + 2 + 1)] = read_imagef(srcRGB, sampler, (int2)(x, y + 1));
        pixel[hook(6, 16 - 1 + 2 + 0)][hook(10, 15 - 1 + 2 + 2)] = read_imagef(srcRGB, sampler, (int2)(x, y + 2));
        pixel[hook(6, 16 - 1 + 2 + 1)][hook(11, 15 - 1 + 2 + 0)] = read_imagef(srcRGB, sampler, (int2)(x + 1, y));
        pixel[hook(6, 16 - 1 + 2 + 1)][hook(11, 15 - 1 + 2 + 1)] = read_imagef(srcRGB, sampler, (int2)(x + 1, y + 1));
        pixel[hook(6, 16 - 1 + 2 + 1)][hook(11, 15 - 1 + 2 + 2)] = read_imagef(srcRGB, sampler, (int2)(x + 1, y + 2));
        pixel[hook(6, 16 - 1 + 2 + 2)][hook(12, 15 - 1 + 2 + 0)] = read_imagef(srcRGB, sampler, (int2)(x + 2, y));
        pixel[hook(6, 16 - 1 + 2 + 2)][hook(12, 15 - 1 + 2 + 1)] = read_imagef(srcRGB, sampler, (int2)(x + 2, y + 1));
        pixel[hook(6, 16 - 1 + 2 + 2)][hook(12, 15 - 1 + 2 + 2)] = read_imagef(srcRGB, sampler, (int2)(x + 2, y + 2));
      } else {
        pixel[hook(6, 16 - 1 + 2 + 1)][hook(11, localY + 2)] = read_imagef(srcRGB, sampler, (int2)(x + 1, y));
        pixel[hook(6, 16 - 1 + 2 + 2)][hook(12, localY + 2)] = read_imagef(srcRGB, sampler, (int2)(x + 2, y));
      }
    } else if (localY == 0) {
      pixel[hook(6, localX + 2)][hook(5, 0)] = read_imagef(srcRGB, sampler, (int2)(x, y - 2));
      pixel[hook(6, localX + 2)][hook(5, 1)] = read_imagef(srcRGB, sampler, (int2)(x, y - 1));
    } else if (localY == 15 - 1) {
      pixel[hook(6, localX + 2)][hook(5, 15 - 1 + 2 + 1)] = read_imagef(srcRGB, sampler, (int2)(x, y + 1));
      pixel[hook(6, localX + 2)][hook(5, 15 - 1 + 2 + 2)] = read_imagef(srcRGB, sampler, (int2)(x, y + 2));
    }
  } else {
    line = read_imagef(srcRGB, sampler, (int2)(x, y));
  }

  barrier(0x01);
  if (interior) {
    for (i = 0; i < 5; i++) {
      for (j = 0; j < 5; j++) {
        delta = pown(pixel[hook(6, localX + i)][hook(13, localY + j)].x - pixel[hook(6, localX + 2)][hook(5, localY + 2)].x, 2) + pown(pixel[hook(6, localX + i)][hook(13, localY + j)].y - pixel[hook(6, localX + 2)][hook(5, localY + 2)].y, 2) + pown(pixel[hook(6, localX + i)][hook(13, localY + j)].z - pixel[hook(6, localX + 2)][hook(5, localY + 2)].z, 2);
        H = (exp(-(delta / sigma_r))) * gausssingle[hook(14, i * 5 + j)];
        normF += H;
        line.x += pixel[hook(6, localX + i)][hook(13, localY + j)].x * H;
        line.y += pixel[hook(6, localX + i)][hook(13, localY + j)].y * H;
        line.z += pixel[hook(6, localX + i)][hook(13, localY + j)].z * H;
      }
    }

    line.x = line.x / normF;
    line.y = line.y / normF;
    line.z = line.z / normF;
  }

  write_imagef(dstRGB, (int2)(x, y), line);
}