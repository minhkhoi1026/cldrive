//{"cubeOffsets":5,"readHistoPyramid":0,"sizeX":2,"sizeY":3,"sizeZ":4,"writeHistoPyramid":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t interpolationSampler = 0 | 2 | 0x20;
constant sampler_t hpSampler = 0 | 4 | 0x10;
void eigen_decomposition(float M[3][3], float V[3][3], float e[3]);
constant int4 cubeOffsets2D[4] = {
    {0, 0, 0, 0},
    {0, 1, 0, 0},
    {1, 0, 0, 0},
    {1, 1, 0, 0},
};

constant int4 cubeOffsets[8] = {
    {0, 0, 0, 0}, {1, 0, 0, 0}, {0, 0, 1, 0}, {1, 0, 1, 0}, {0, 1, 0, 0}, {1, 1, 0, 0}, {0, 1, 1, 0}, {1, 1, 1, 0},
};

float3 gradientNormalized(read_only image3d_t volume, int4 pos, int volumeComponent, int dimensions) {
  float f100, f_100, f010, f0_10, f001, f00_1;
  switch (volumeComponent) {
    case 0:
      f100 = read_imagef(volume, sampler, pos + (int4)(1, 0, 0, 0)).x;
      f_100 = read_imagef(volume, sampler, pos - (int4)(1, 0, 0, 0)).x;
      if (dimensions > 1) {
        f010 = read_imagef(volume, sampler, pos + (int4)(0, 1, 0, 0)).x;
        f0_10 = read_imagef(volume, sampler, pos - (int4)(0, 1, 0, 0)).x;
      }
      if (dimensions > 2) {
        f001 = read_imagef(volume, sampler, pos + (int4)(0, 0, 1, 0)).x;
        f00_1 = read_imagef(volume, sampler, pos - (int4)(0, 0, 1, 0)).x;
      }
      break;
    case 1:
      f100 = read_imagef(volume, sampler, pos + (int4)(1, 0, 0, 0)).y;
      f_100 = read_imagef(volume, sampler, pos - (int4)(1, 0, 0, 0)).y;
      if (dimensions > 1) {
        f010 = read_imagef(volume, sampler, pos + (int4)(0, 1, 0, 0)).y;
        f0_10 = read_imagef(volume, sampler, pos - (int4)(0, 1, 0, 0)).y;
      }
      if (dimensions > 2) {
        f001 = read_imagef(volume, sampler, pos + (int4)(0, 0, 1, 0)).y;
        f00_1 = read_imagef(volume, sampler, pos - (int4)(0, 0, 1, 0)).y;
      }
      break;
    case 2:
      f100 = read_imagef(volume, sampler, pos + (int4)(1, 0, 0, 0)).z;
      f_100 = read_imagef(volume, sampler, pos - (int4)(1, 0, 0, 0)).z;
      if (dimensions > 1) {
        f010 = read_imagef(volume, sampler, pos + (int4)(0, 1, 0, 0)).z;
        f0_10 = read_imagef(volume, sampler, pos - (int4)(0, 1, 0, 0)).z;
      }
      if (dimensions > 2) {
        f001 = read_imagef(volume, sampler, pos + (int4)(0, 0, 1, 0)).z;
        f00_1 = read_imagef(volume, sampler, pos - (int4)(0, 0, 1, 0)).z;
      }
      break;
  }

  float3 grad = {0.5f * (f100 / read_imagef(volume, sampler, pos + (int4)(1, 0, 0, 0)).w - f_100 / read_imagef(volume, sampler, pos - (int4)(1, 0, 0, 0)).w), 0.5f * (f010 / read_imagef(volume, sampler, pos + (int4)(0, 1, 0, 0)).w - f0_10 / read_imagef(volume, sampler, pos - (int4)(0, 1, 0, 0)).w), 0.5f * (f001 / read_imagef(volume, sampler, pos + (int4)(0, 0, 1, 0)).w - f00_1 / read_imagef(volume, sampler, pos - (int4)(0, 0, 1, 0)).w)};

  return grad;
}

float3 gradient(read_only image3d_t volume, int4 pos, int volumeComponent, int dimensions) {
  float f100, f_100, f010, f0_10, f001, f00_1;
  switch (volumeComponent) {
    case 0:
      f100 = read_imagef(volume, sampler, pos + (int4)(1, 0, 0, 0)).x;
      f_100 = read_imagef(volume, sampler, pos - (int4)(1, 0, 0, 0)).x;
      if (dimensions > 1) {
        f010 = read_imagef(volume, sampler, pos + (int4)(0, 1, 0, 0)).x;
        f0_10 = read_imagef(volume, sampler, pos - (int4)(0, 1, 0, 0)).x;
      }
      if (dimensions > 2) {
        f001 = read_imagef(volume, sampler, pos + (int4)(0, 0, 1, 0)).x;
        f00_1 = read_imagef(volume, sampler, pos - (int4)(0, 0, 1, 0)).x;
      }
      break;
    case 1:
      f100 = read_imagef(volume, sampler, pos + (int4)(1, 0, 0, 0)).y;
      f_100 = read_imagef(volume, sampler, pos - (int4)(1, 0, 0, 0)).y;
      if (dimensions > 1) {
        f010 = read_imagef(volume, sampler, pos + (int4)(0, 1, 0, 0)).y;
        f0_10 = read_imagef(volume, sampler, pos - (int4)(0, 1, 0, 0)).y;
      }
      if (dimensions > 2) {
        f001 = read_imagef(volume, sampler, pos + (int4)(0, 0, 1, 0)).y;
        f00_1 = read_imagef(volume, sampler, pos - (int4)(0, 0, 1, 0)).y;
      }
      break;
    case 2:
      f100 = read_imagef(volume, sampler, pos + (int4)(1, 0, 0, 0)).z;
      f_100 = read_imagef(volume, sampler, pos - (int4)(1, 0, 0, 0)).z;
      if (dimensions > 1) {
        f010 = read_imagef(volume, sampler, pos + (int4)(0, 1, 0, 0)).z;
        f0_10 = read_imagef(volume, sampler, pos - (int4)(0, 1, 0, 0)).z;
      }
      if (dimensions > 2) {
        f001 = read_imagef(volume, sampler, pos + (int4)(0, 0, 1, 0)).z;
        f00_1 = read_imagef(volume, sampler, pos - (int4)(0, 0, 1, 0)).z;
      }
      break;
  }

  float3 grad = {0.5f * (f100 - f_100), 0.5f * (f010 - f0_10), 0.5f * (f001 - f00_1)};

  return grad;
}

unsigned int Part1By2(unsigned int x) {
  x &= 0x000003ff;
  x = (x ^ (x << 16)) & 0xff0000ff;
  x = (x ^ (x << 8)) & 0x0300f00f;
  x = (x ^ (x << 4)) & 0x030c30c3;
  x = (x ^ (x << 2)) & 0x09249249;
  return x;
}

unsigned int EncodeMorton3(unsigned int x, unsigned int y, unsigned int z) {
  return (Part1By2(z) << 2) + (Part1By2(y) << 1) + Part1By2(x);
}

unsigned int EncodeMorton(int4 v) {
  return EncodeMorton3(v.x, v.y, v.z);
}

unsigned int Compact1By2(unsigned int x) {
  x &= 0x09249249;
  x = (x ^ (x >> 2)) & 0x030c30c3;
  x = (x ^ (x >> 4)) & 0x0300f00f;
  x = (x ^ (x >> 8)) & 0xff0000ff;
  x = (x ^ (x >> 16)) & 0x000003ff;
  return x;
}

unsigned int DecodeMorton3X(unsigned int code) {
  return Compact1By2(code >> 0);
}

unsigned int DecodeMorton3Y(unsigned int code) {
  return Compact1By2(code >> 1);
}

unsigned int DecodeMorton3Z(unsigned int code) {
  return Compact1By2(code >> 2);
}

kernel void constructHPLevelCharChar(global uchar* readHistoPyramid, global uchar* writeHistoPyramid, private int sizeX, private int sizeY, private int sizeZ) {
  uint3 size = {sizeX, sizeY, sizeZ};

  unsigned int writePos = EncodeMorton3(get_global_id(0), get_global_id(1), get_global_id(2));
  int4 readPos = (int4)(get_global_id(0) * 2, get_global_id(1) * 2, get_global_id(2) * 2, 0);
  uchar writeValue;
  if (readPos.x >= size.x || readPos.y >= size.y || readPos.z >= size.z) {
    writeValue = 0;
  } else {
    writeValue = readHistoPyramid[hook(0, ((readPos).x) + ((readPos).y) * size.x + ((readPos).z) * size.x * size.y)] + readHistoPyramid[hook(0, ((readPos + cubeOffsets[1hook(5, 1)).x) + ((readPos + cubeOffsets[1hook(5, 1)).y) * size.x + ((readPos + cubeOffsets[1hook(5, 1)).z) * size.x * size.y)] + readHistoPyramid[hook(0, ((readPos + cubeOffsets[2hook(5, 2)).x) + ((readPos + cubeOffsets[2hook(5, 2)).y) * size.x + ((readPos + cubeOffsets[2hook(5, 2)).z) * size.x * size.y)] + readHistoPyramid[hook(0, ((readPos + cubeOffsets[3hook(5, 3)).x) + ((readPos + cubeOffsets[3hook(5, 3)).y) * size.x + ((readPos + cubeOffsets[3hook(5, 3)).z) * size.x * size.y)] + readHistoPyramid[hook(0, ((readPos + cubeOffsets[4hook(5, 4)).x) + ((readPos + cubeOffsets[4hook(5, 4)).y) * size.x + ((readPos + cubeOffsets[4hook(5, 4)).z) * size.x * size.y)] + readHistoPyramid[hook(0, ((readPos + cubeOffsets[5hook(5, 5)).x) + ((readPos + cubeOffsets[5hook(5, 5)).y) * size.x + ((readPos + cubeOffsets[5hook(5, 5)).z) * size.x * size.y)] + readHistoPyramid[hook(0, ((readPos + cubeOffsets[6hook(5, 6)).x) + ((readPos + cubeOffsets[6hook(5, 6)).y) * size.x + ((readPos + cubeOffsets[6hook(5, 6)).z) * size.x * size.y)] + readHistoPyramid[hook(0, ((readPos + cubeOffsets[7hook(5, 7)).x) + ((readPos + cubeOffsets[7hook(5, 7)).y) * size.x + ((readPos + cubeOffsets[7hook(5, 7)).z) * size.x * size.y)];
  }

  writeHistoPyramid[hook(1, writePos)] = writeValue;
}