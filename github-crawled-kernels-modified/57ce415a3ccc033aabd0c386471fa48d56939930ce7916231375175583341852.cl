//{"A":14,"A[i]":13,"V":7,"V[3 - 1]":6,"V[i - 1]":9,"V[i]":10,"V[j]":11,"V[k]":12,"cubeOffsets":4,"cubeOffsets2D":2,"d":5,"e":8,"hp":3,"v_read":0,"v_write":1}
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

  current += cubeOffsets2D[hook(2, (cmp.s0 + cmp.s1 + cmp.s2))].xyz;
  current.x = current.x * 2;
  current.y = current.y * 2;
  current.z = current.z + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2;
  return current;
}

int4 scanHPLevelShort(int target, global ushort* hp, int4 current) {
  int8 neighbors = {
      hp[hook(3, EncodeMorton(current))], hp[hook(3, EncodeMorton(current + cubeOffsets[1hook(4, 1)))], hp[hook(3, EncodeMorton(current + cubeOffsets[2hook(4, 2)))], hp[hook(3, EncodeMorton(current + cubeOffsets[3hook(4, 3)))], hp[hook(3, EncodeMorton(current + cubeOffsets[4hook(4, 4)))], hp[hook(3, EncodeMorton(current + cubeOffsets[5hook(4, 5)))], hp[hook(3, EncodeMorton(current + cubeOffsets[6hook(4, 6)))], hp[hook(3, EncodeMorton(current + cubeOffsets[7hook(4, 7)))],
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

  current += cubeOffsets[hook(4, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}

int4 scanHPLevelChar(int target, global uchar* hp, int4 current) {
  int8 neighbors = {
      hp[hook(3, EncodeMorton(current))], hp[hook(3, EncodeMorton(current + cubeOffsets[1hook(4, 1)))], hp[hook(3, EncodeMorton(current + cubeOffsets[2hook(4, 2)))], hp[hook(3, EncodeMorton(current + cubeOffsets[3hook(4, 3)))], hp[hook(3, EncodeMorton(current + cubeOffsets[4hook(4, 4)))], hp[hook(3, EncodeMorton(current + cubeOffsets[5hook(4, 5)))], hp[hook(3, EncodeMorton(current + cubeOffsets[6hook(4, 6)))], hp[hook(3, EncodeMorton(current + cubeOffsets[7hook(4, 7)))],
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

  current += cubeOffsets[hook(4, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}
int4 scanHPLevelCharNoMorton(int target, global uchar* hp, int4 current, uint3 size) {
  int8 neighbors = {
      hp[hook(3, ((current).x) + ((current).y) * size.x + ((current).z) * size.x * size.y)], hp[hook(3, ((current + cubeOffsets[1hook(4, 1)).x) + ((current + cubeOffsets[1hook(4, 1)).y) * size.x + ((current + cubeOffsets[1hook(4, 1)).z) * size.x * size.y)], hp[hook(3, ((current + cubeOffsets[2hook(4, 2)).x) + ((current + cubeOffsets[2hook(4, 2)).y) * size.x + ((current + cubeOffsets[2hook(4, 2)).z) * size.x * size.y)], hp[hook(3, ((current + cubeOffsets[3hook(4, 3)).x) + ((current + cubeOffsets[3hook(4, 3)).y) * size.x + ((current + cubeOffsets[3hook(4, 3)).z) * size.x * size.y)], hp[hook(3, ((current + cubeOffsets[4hook(4, 4)).x) + ((current + cubeOffsets[4hook(4, 4)).y) * size.x + ((current + cubeOffsets[4hook(4, 4)).z) * size.x * size.y)], hp[hook(3, ((current + cubeOffsets[5hook(4, 5)).x) + ((current + cubeOffsets[5hook(4, 5)).y) * size.x + ((current + cubeOffsets[5hook(4, 5)).z) * size.x * size.y)], hp[hook(3, ((current + cubeOffsets[6hook(4, 6)).x) + ((current + cubeOffsets[6hook(4, 6)).y) * size.x + ((current + cubeOffsets[6hook(4, 6)).z) * size.x * size.y)], hp[hook(3, ((current + cubeOffsets[7hook(4, 7)).x) + ((current + cubeOffsets[7hook(4, 7)).y) * size.x + ((current + cubeOffsets[7hook(4, 7)).z) * size.x * size.y)],
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

  current += cubeOffsets[hook(4, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}

int4 scanHPLevel(int target, global int* hp, int4 current) {
  int8 neighbors = {
      hp[hook(3, EncodeMorton(current))], hp[hook(3, EncodeMorton(current + cubeOffsets[1hook(4, 1)))], hp[hook(3, EncodeMorton(current + cubeOffsets[2hook(4, 2)))], hp[hook(3, EncodeMorton(current + cubeOffsets[3hook(4, 3)))], hp[hook(3, EncodeMorton(current + cubeOffsets[4hook(4, 4)))], hp[hook(3, EncodeMorton(current + cubeOffsets[5hook(4, 5)))], hp[hook(3, EncodeMorton(current + cubeOffsets[6hook(4, 6)))], hp[hook(3, EncodeMorton(current + cubeOffsets[7hook(4, 7)))],
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

  current += cubeOffsets[hook(4, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
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

constant float cosValues[32] = {1.0f, 0.540302f, -0.416147f, -0.989992f, -0.653644f, 0.283662f, 0.96017f, 0.753902f, -0.1455f, -0.91113f, -0.839072f, 0.0044257f, 0.843854f, 0.907447f, 0.136737f, -0.759688f, -0.957659f, -0.275163f, 0.660317f, 0.988705f, 0.408082f, -0.547729f, -0.999961f, -0.532833f, 0.424179f, 0.991203f, 0.646919f, -0.292139f, -0.962606f, -0.748058f, 0.154251f, 0.914742f};
constant float sinValues[32] = {0.0f, 0.841471f, 0.909297f, 0.14112f, -0.756802f, -0.958924f, -0.279415f, 0.656987f, 0.989358f, 0.412118f, -0.544021f, -0.99999f, -0.536573f, 0.420167f, 0.990607f, 0.650288f, -0.287903f, -0.961397f, -0.750987f, 0.149877f, 0.912945f, 0.836656f, -0.00885131f, -0.84622f, -0.905578f, -0.132352f, 0.762558f, 0.956376f, 0.270906f, -0.663634f, -0.988032f, -0.404038f};

float hypot2(float x, float y) {
  return sqrt(x * x + y * y);
}

void tred2(float V[3][3], float d[3], float e[3]) {
  for (int j = 0; j < 3; j++) {
    d[hook(5, j)] = V[hook(7, 3 - 1)][hook(6, j)];
  }

  for (int i = 3 - 1; i > 0; i--) {
    float scale = 0.0f;
    float h = 0.0f;
    for (int k = 0; k < i; k++) {
      scale = scale + fabs(d[hook(5, k)]);
    }
    if (scale == 0.0f) {
      e[hook(8, i)] = d[hook(5, i - 1)];
      for (int j = 0; j < i; j++) {
        d[hook(5, j)] = V[hook(7, i - 1)][hook(9, j)];
        V[hook(7, i)][hook(10, j)] = 0.0f;
        V[hook(7, j)][hook(11, i)] = 0.0f;
      }
    } else {
      for (int k = 0; k < i; k++) {
        d[hook(5, k)] /= scale;
        h += d[hook(5, k)] * d[hook(5, k)];
      }
      float f = d[hook(5, i - 1)];
      float g = sqrt(h);
      if (f > 0) {
        g = -g;
      }
      e[hook(8, i)] = scale * g;
      h = h - f * g;
      d[hook(5, i - 1)] = f - g;
      for (int j = 0; j < i; j++) {
        e[hook(8, j)] = 0.0f;
      }

      for (int j = 0; j < i; j++) {
        f = d[hook(5, j)];
        V[hook(7, j)][hook(11, i)] = f;
        g = e[hook(8, j)] + V[hook(7, j)][hook(11, j)] * f;
        for (int k = j + 1; k <= i - 1; k++) {
          g += V[hook(7, k)][hook(12, j)] * d[hook(5, k)];
          e[hook(8, k)] += V[hook(7, k)][hook(12, j)] * f;
        }
        e[hook(8, j)] = g;
      }
      f = 0.0f;
      for (int j = 0; j < i; j++) {
        e[hook(8, j)] /= h;
        f += e[hook(8, j)] * d[hook(5, j)];
      }
      float hh = f / (h + h);
      for (int j = 0; j < i; j++) {
        e[hook(8, j)] -= hh * d[hook(5, j)];
      }
      for (int j = 0; j < i; j++) {
        f = d[hook(5, j)];
        g = e[hook(8, j)];
        for (int k = j; k <= i - 1; k++) {
          V[hook(7, k)][hook(12, j)] -= (f * e[hook(8, k)] + g * d[hook(5, k)]);
        }
        d[hook(5, j)] = V[hook(7, i - 1)][hook(9, j)];
        V[hook(7, i)][hook(10, j)] = 0.0f;
      }
    }
    d[hook(5, i)] = h;
  }

  for (int i = 0; i < 3 - 1; i++) {
    V[hook(7, 3 - 1)][hook(6, i)] = V[hook(7, i)][hook(10, i)];
    V[hook(7, i)][hook(10, i)] = 1.0f;
    float h = d[hook(5, i + 1)];
    if (h != 0.0f) {
      for (int k = 0; k <= i; k++) {
        d[hook(5, k)] = V[hook(7, k)][hook(12, i + 1)] / h;
      }
      for (int j = 0; j <= i; j++) {
        float g = 0.0f;
        for (int k = 0; k <= i; k++) {
          g += V[hook(7, k)][hook(12, i + 1)] * V[hook(7, k)][hook(12, j)];
        }
        for (int k = 0; k <= i; k++) {
          V[hook(7, k)][hook(12, j)] -= g * d[hook(5, k)];
        }
      }
    }
    for (int k = 0; k <= i; k++) {
      V[hook(7, k)][hook(12, i + 1)] = 0.0f;
    }
  }
  for (int j = 0; j < 3; j++) {
    d[hook(5, j)] = V[hook(7, 3 - 1)][hook(6, j)];
    V[hook(7, 3 - 1)][hook(6, j)] = 0.0f;
  }
  V[hook(7, 3 - 1)][hook(6, 3 - 1)] = 1.0f;
  e[hook(8, 0)] = 0.0f;
}

void tql2(float V[3][3], float d[3], float e[3]) {
  for (int i = 1; i < 3; i++) {
    e[hook(8, i - 1)] = e[hook(8, i)];
  }
  e[hook(8, 3 - 1)] = 0.0f;

  float f = 0.0f;
  float tst1 = 0.0f;
  float eps = pow(2.0f, -52.0f);
  for (int l = 0; l < 3; l++) {
    tst1 = ((tst1) > (fabs(d[hook(5, l)]) + fabs(e[hook(8, l)])) ? (tst1) : (fabs(d[hook(5, l)]) + fabs(e[hook(8, l)])));
    int m = l;
    while (m < 3) {
      if (fabs(e[hook(8, m)]) <= eps * tst1) {
        break;
      }
      m++;
    }

    if (m > l) {
      int iter = 0;
      do {
        iter = iter + 1;

        float g = d[hook(5, l)];
        float p = (d[hook(5, l + 1)] - g) / (2.0f * e[hook(8, l)]);
        float r = hypot2(p, 1.0f);
        if (p < 0) {
          r = -r;
        }
        d[hook(5, l)] = e[hook(8, l)] / (p + r);
        d[hook(5, l + 1)] = e[hook(8, l)] * (p + r);
        float dl1 = d[hook(5, l + 1)];
        float h = g - d[hook(5, l)];
        for (int i = l + 2; i < 3; i++) {
          d[hook(5, i)] -= h;
        }
        f = f + h;

        p = d[hook(5, m)];
        float c = 1.0f;
        float c2 = c;
        float c3 = c;
        float el1 = e[hook(8, l + 1)];
        float s = 0.0f;
        float s2 = 0.0f;
        for (int i = m - 1; i >= l; i--) {
          c3 = c2;
          c2 = c;
          s2 = s;
          g = c * e[hook(8, i)];
          h = c * p;
          r = hypot2(p, e[hook(8, i)]);
          e[hook(8, i + 1)] = s * r;
          s = e[hook(8, i)] / r;
          c = p / r;
          p = c * d[hook(5, i)] - s * g;
          d[hook(5, i + 1)] = h + s * (c * g + s * d[hook(5, i)]);

          for (int k = 0; k < 3; k++) {
            h = V[hook(7, k)][hook(12, i + 1)];
            V[hook(7, k)][hook(12, i + 1)] = s * V[hook(7, k)][hook(12, i)] + c * h;
            V[hook(7, k)][hook(12, i)] = c * V[hook(7, k)][hook(12, i)] - s * h;
          }
        }
        p = -s * s2 * c3 * el1 * e[hook(8, l)] / dl1;
        e[hook(8, l)] = s * p;
        d[hook(5, l)] = c * p;

      } while (fabs(e[hook(8, l)]) > eps * tst1);
    }
    d[hook(5, l)] = d[hook(5, l)] + f;
    e[hook(8, l)] = 0.0f;
  }

  for (int i = 0; i < 3 - 1; i++) {
    int k = i;
    float p = d[hook(5, i)];
    for (int j = i + 1; j < 3; j++) {
      if (fabs(d[hook(5, j)]) < fabs(p)) {
        k = j;
        p = d[hook(5, j)];
      }
    }
    if (k != i) {
      d[hook(5, k)] = d[hook(5, i)];
      d[hook(5, i)] = p;
      for (int j = 0; j < 3; j++) {
        p = V[hook(7, j)][hook(11, i)];
        V[hook(7, j)][hook(11, i)] = V[hook(7, j)][hook(11, k)];
        V[hook(7, j)][hook(11, k)] = p;
      }
    }
  }
}

void eigen_decomposition(float A[3][3], float V[3][3], float d[3]) {
  float e[3];
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      V[hook(7, i)][hook(10, j)] = A[hook(14, i)][hook(13, j)];
    }
  }
  tred2(V, d, e);
  tql2(V, d, e);
}

kernel void restrictVolume(read_only image3d_t v_read, global float* v_write) {
  int4 writePos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};

  int4 size = {get_global_size(0) * 2, get_global_size(1) * 2, get_global_size(2) * 2, 0};
  int4 pos = writePos * 2;
  pos = select(pos, size - 3, pos >= size - 1);

  const int4 readPos = pos;
  const float value = 0.125 * (read_imagef(v_read, hpSampler, readPos + (int4)(0, 0, 0, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(1, 0, 0, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(0, 1, 0, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(0, 0, 1, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(1, 1, 0, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(0, 1, 1, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(1, 1, 1, 0)).x + read_imagef(v_read, hpSampler, readPos + (int4)(1, 0, 1, 0)).x);

  v_write[hook(1, writePos.x + writePos.y * get_global_size(0) + writePos.z * get_global_size(0) * get_global_size(1))] = value;
}