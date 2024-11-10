//{"cubeOffsets":6,"cubeOffsets2D":4,"currentSegmentation":0,"gvf":1,"hp":5,"nextSegmentation":2,"stop":3}
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

int3 scanHPLevel2D(int target, read_only image2d_t hp, int3 current) {
  int4 neighbors = {read_imagei(hp, hpSampler, current.xy).x, read_imagei(hp, hpSampler, current.xy + (int2)(0, 1)).x, read_imagei(hp, hpSampler, current.xy + (int2)(1, 0)).x, 0};

  int acc = current.z + neighbors.s0;
  int4 cmp;
  cmp.s0 = acc <= target;
  acc += neighbors.s1;
  cmp.s1 = acc <= target;
  acc += neighbors.s2;
  cmp.s2 = acc <= target;

  current += cubeOffsets2D[hook(4, (cmp.s0 + cmp.s1 + cmp.s2))].xyz;
  current.x = current.x * 2;
  current.y = current.y * 2;
  current.z = current.z + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2;
  return current;
}

int4 scanHPLevelShort(int target, global ushort* hp, int4 current) {
  int8 neighbors = {
      hp[hook(5, EncodeMorton(current))], hp[hook(5, EncodeMorton(current + cubeOffsets[1hook(6, 1)))], hp[hook(5, EncodeMorton(current + cubeOffsets[2hook(6, 2)))], hp[hook(5, EncodeMorton(current + cubeOffsets[3hook(6, 3)))], hp[hook(5, EncodeMorton(current + cubeOffsets[4hook(6, 4)))], hp[hook(5, EncodeMorton(current + cubeOffsets[5hook(6, 5)))], hp[hook(5, EncodeMorton(current + cubeOffsets[6hook(6, 6)))], hp[hook(5, EncodeMorton(current + cubeOffsets[7hook(6, 7)))],
  };

  int acc = current.s3 + neighbors.s0;
  int8 cmp;
  cmp.s0 = acc <= target;
  acc += neighbors.s1;
  cmp.s1 = acc <= target;
  acc += neighbors.s2;
  cmp.s2 = acc <= target;
  acc += neighbors.s3;
  cmp.s3 = acc <= target;
  acc += neighbors.s4;
  cmp.s4 = acc <= target;
  acc += neighbors.s5;
  cmp.s5 = acc <= target;
  acc += neighbors.s6;
  cmp.s6 = acc <= target;
  cmp.s7 = 0;

  current += cubeOffsets[hook(6, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}

int4 scanHPLevelChar(int target, global uchar* hp, int4 current) {
  int8 neighbors = {
      hp[hook(5, EncodeMorton(current))], hp[hook(5, EncodeMorton(current + cubeOffsets[1hook(6, 1)))], hp[hook(5, EncodeMorton(current + cubeOffsets[2hook(6, 2)))], hp[hook(5, EncodeMorton(current + cubeOffsets[3hook(6, 3)))], hp[hook(5, EncodeMorton(current + cubeOffsets[4hook(6, 4)))], hp[hook(5, EncodeMorton(current + cubeOffsets[5hook(6, 5)))], hp[hook(5, EncodeMorton(current + cubeOffsets[6hook(6, 6)))], hp[hook(5, EncodeMorton(current + cubeOffsets[7hook(6, 7)))],
  };

  int acc = current.s3 + neighbors.s0;
  int8 cmp;
  cmp.s0 = acc <= target;
  acc += neighbors.s1;
  cmp.s1 = acc <= target;
  acc += neighbors.s2;
  cmp.s2 = acc <= target;
  acc += neighbors.s3;
  cmp.s3 = acc <= target;
  acc += neighbors.s4;
  cmp.s4 = acc <= target;
  acc += neighbors.s5;
  cmp.s5 = acc <= target;
  acc += neighbors.s6;
  cmp.s6 = acc <= target;
  cmp.s7 = 0;

  current += cubeOffsets[hook(6, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}
int4 scanHPLevelCharNoMorton(int target, global uchar* hp, int4 current, uint3 size) {
  int8 neighbors = {
      hp[hook(5, ((current).x) + ((current).y) * size.x + ((current).z) * size.x * size.y)], hp[hook(5, ((current + cubeOffsets[1hook(6, 1)).x) + ((current + cubeOffsets[1hook(6, 1)).y) * size.x + ((current + cubeOffsets[1hook(6, 1)).z) * size.x * size.y)], hp[hook(5, ((current + cubeOffsets[2hook(6, 2)).x) + ((current + cubeOffsets[2hook(6, 2)).y) * size.x + ((current + cubeOffsets[2hook(6, 2)).z) * size.x * size.y)], hp[hook(5, ((current + cubeOffsets[3hook(6, 3)).x) + ((current + cubeOffsets[3hook(6, 3)).y) * size.x + ((current + cubeOffsets[3hook(6, 3)).z) * size.x * size.y)], hp[hook(5, ((current + cubeOffsets[4hook(6, 4)).x) + ((current + cubeOffsets[4hook(6, 4)).y) * size.x + ((current + cubeOffsets[4hook(6, 4)).z) * size.x * size.y)], hp[hook(5, ((current + cubeOffsets[5hook(6, 5)).x) + ((current + cubeOffsets[5hook(6, 5)).y) * size.x + ((current + cubeOffsets[5hook(6, 5)).z) * size.x * size.y)], hp[hook(5, ((current + cubeOffsets[6hook(6, 6)).x) + ((current + cubeOffsets[6hook(6, 6)).y) * size.x + ((current + cubeOffsets[6hook(6, 6)).z) * size.x * size.y)], hp[hook(5, ((current + cubeOffsets[7hook(6, 7)).x) + ((current + cubeOffsets[7hook(6, 7)).y) * size.x + ((current + cubeOffsets[7hook(6, 7)).z) * size.x * size.y)],
  };

  int acc = current.s3 + neighbors.s0;
  int8 cmp;
  cmp.s0 = acc <= target;
  acc += neighbors.s1;
  cmp.s1 = acc <= target;
  acc += neighbors.s2;
  cmp.s2 = acc <= target;
  acc += neighbors.s3;
  cmp.s3 = acc <= target;
  acc += neighbors.s4;
  cmp.s4 = acc <= target;
  acc += neighbors.s5;
  cmp.s5 = acc <= target;
  acc += neighbors.s6;
  cmp.s6 = acc <= target;
  cmp.s7 = 0;

  current += cubeOffsets[hook(6, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}

int4 scanHPLevel(int target, global int* hp, int4 current) {
  int8 neighbors = {
      hp[hook(5, EncodeMorton(current))], hp[hook(5, EncodeMorton(current + cubeOffsets[1hook(6, 1)))], hp[hook(5, EncodeMorton(current + cubeOffsets[2hook(6, 2)))], hp[hook(5, EncodeMorton(current + cubeOffsets[3hook(6, 3)))], hp[hook(5, EncodeMorton(current + cubeOffsets[4hook(6, 4)))], hp[hook(5, EncodeMorton(current + cubeOffsets[5hook(6, 5)))], hp[hook(5, EncodeMorton(current + cubeOffsets[6hook(6, 6)))], hp[hook(5, EncodeMorton(current + cubeOffsets[7hook(6, 7)))],
  };

  int acc = current.s3 + neighbors.s0;
  int8 cmp;
  cmp.s0 = acc <= target;
  acc += neighbors.s1;
  cmp.s1 = acc <= target;
  acc += neighbors.s2;
  cmp.s2 = acc <= target;
  acc += neighbors.s3;
  cmp.s3 = acc <= target;
  acc += neighbors.s4;
  cmp.s4 = acc <= target;
  acc += neighbors.s5;
  cmp.s5 = acc <= target;
  acc += neighbors.s6;
  cmp.s6 = acc <= target;
  cmp.s7 = 0;

  current += cubeOffsets[hook(6, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}

int4 traverseHP3DBuffer(uint3 size, int target, int HP_SIZE, global uchar* hp0, global uchar* hp1, global ushort* hp2, global ushort* hp3, global ushort* hp4, global int* hp5, global int* hp6, global int* hp7, global int* hp8, global int* hp9) {
  int4 position = {0, 0, 0, 0};
  if (HP_SIZE > 512)
    position = scanHPLevel(target, hp9, position);
  if (HP_SIZE > 256)
    position = scanHPLevel(target, hp8, position);
  if (HP_SIZE > 128)
    position = scanHPLevel(target, hp7, position);
  if (HP_SIZE > 64)
    position = scanHPLevel(target, hp6, position);
  if (HP_SIZE > 32)
    position = scanHPLevel(target, hp5, position);
  if (HP_SIZE > 16)
    position = scanHPLevelShort(target, hp4, position);
  if (HP_SIZE > 8)
    position = scanHPLevelShort(target, hp3, position);
  position = scanHPLevelShort(target, hp2, position);
  position = scanHPLevelChar(target, hp1, position);
  position = scanHPLevelCharNoMorton(target, hp0, position, size);
  position.x = position.x / 2;
  position.y = position.y / 2;
  position.z = position.z / 2;
  return position;
}

int2 traverseHP2D(int target, int HP_SIZE, image2d_t hp0, image2d_t hp1, image2d_t hp2, image2d_t hp3, image2d_t hp4, image2d_t hp5, image2d_t hp6, image2d_t hp7, image2d_t hp8, image2d_t hp9, image2d_t hp10, image2d_t hp11, image2d_t hp12, image2d_t hp13) {
  int3 position = {0, 0, 0};
  if (HP_SIZE > 8192)
    position = scanHPLevel2D(target, hp13, position);
  if (HP_SIZE > 4096)
    position = scanHPLevel2D(target, hp12, position);
  if (HP_SIZE > 2048)
    position = scanHPLevel2D(target, hp11, position);
  if (HP_SIZE > 1024)
    position = scanHPLevel2D(target, hp10, position);
  if (HP_SIZE > 512)
    position = scanHPLevel2D(target, hp9, position);
  if (HP_SIZE > 256)
    position = scanHPLevel2D(target, hp8, position);
  if (HP_SIZE > 128)
    position = scanHPLevel2D(target, hp7, position);
  if (HP_SIZE > 64)
    position = scanHPLevel2D(target, hp6, position);
  if (HP_SIZE > 32)
    position = scanHPLevel2D(target, hp5, position);
  if (HP_SIZE > 16)
    position = scanHPLevel2D(target, hp4, position);
  if (HP_SIZE > 8)
    position = scanHPLevel2D(target, hp3, position);
  position = scanHPLevel2D(target, hp2, position);
  position = scanHPLevel2D(target, hp1, position);
  position = scanHPLevel2D(target, hp0, position);
  position.x = position.x / 2;
  position.y = position.y / 2;
  return position.xy;
}

kernel void grow(read_only image3d_t currentSegmentation, read_only image3d_t gvf, global char* nextSegmentation, global int* stop) {
  int4 X = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  char value = read_imagei(currentSegmentation, sampler, X).x;

  if (value == 1) {
    nextSegmentation[hook(2, X.x + X.y * get_global_size(0) + X.z * get_global_size(0) * get_global_size(1))] = 1;
  } else if (value == 2) {
    float FNXw = read_imagef(gvf, sampler, X).w;

    bool continueGrowing = false;
    for (int a = -1; a < 2; a++) {
      for (int b = -1; b < 2; b++) {
        for (int c = -1; c < 2; c++) {
          if (a == 0 && b == 0 && c == 0)
            continue;

          int4 Y;
          Y.x = X.x + a;
          Y.y = X.y + b;
          Y.z = X.z + c;

          char valueY = read_imagei(currentSegmentation, sampler, Y).x;
          if (valueY != 1) {
            float4 FNY = read_imagef(gvf, sampler, Y);
            FNY.x /= FNY.w;
            FNY.y /= FNY.w;
            FNY.z /= FNY.w;
            if (FNY.w > FNXw) {
              int4 Z;
              float maxDotProduct = -2.0f;
              for (int a2 = -1; a2 < 2; a2++) {
                for (int b2 = -1; b2 < 2; b2++) {
                  for (int c2 = -1; c2 < 2; c2++) {
                    if (a2 == 0 && b2 == 0 && c2 == 0)
                      continue;
                    int4 Zc;
                    Zc.x = Y.x + a2;
                    Zc.y = Y.y + b2;
                    Zc.z = Y.z + c2;
                    float3 YZ;
                    YZ.x = Zc.x - Y.x;
                    YZ.y = Zc.y - Y.y;
                    YZ.z = Zc.z - Y.z;
                    YZ = normalize(YZ);
                    const float v = FNY.x * YZ.x + FNY.y * YZ.y + FNY.z * YZ.z;
                    if (v > maxDotProduct) {
                      maxDotProduct = v;
                      Z = Zc;
                    }
                  }
                }
              }

              if (Z.x == X.x && Z.y == X.y && Z.z == X.z) {
                nextSegmentation[hook(2, X.x + X.y * get_global_size(0) + X.z * get_global_size(0) * get_global_size(1))] = 1;

                if (Y.x >= 0 && Y.y >= 0 && Y.z >= 0 && Y.x < get_global_size(0) && Y.y < get_global_size(1) && Y.z < get_global_size(2)) {
                  nextSegmentation[hook(2, Y.x + Y.y * get_global_size(0) + Y.z * get_global_size(0) * get_global_size(1))] = 2;
                  continueGrowing = true;
                }
              }
            }
          }
        }
      }
    }

    if (continueGrowing) {
      stop[hook(3, 0)] = 0;
    } else {
      nextSegmentation[hook(2, X.x + X.y * get_global_size(0) + X.z * get_global_size(0) * get_global_size(1))] = 0;
    }
  }
}