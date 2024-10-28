//{"R":6,"T":1,"arms":5,"cubeOffsets":10,"cubeOffsets2D":8,"eigenVectors":12,"eigenVectors[0]":11,"eigenVectors[1]":13,"eigenVectors[2]":14,"hp":9,"maxRadius":15,"minAverageMag":7,"rMax":3,"rMin":2,"rStep":4,"vectorField":0}
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

  current += cubeOffsets2D[hook(8, (cmp.s0 + cmp.s1 + cmp.s2))].xyz;
  current.x = current.x * 2;
  current.y = current.y * 2;
  current.z = current.z + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2;
  return current;
}

int4 scanHPLevelShort(int target, global ushort* hp, int4 current) {
  int8 neighbors = {
      hp[hook(9, EncodeMorton(current))], hp[hook(9, EncodeMorton(current + cubeOffsets[1hook(10, 1)))], hp[hook(9, EncodeMorton(current + cubeOffsets[2hook(10, 2)))], hp[hook(9, EncodeMorton(current + cubeOffsets[3hook(10, 3)))], hp[hook(9, EncodeMorton(current + cubeOffsets[4hook(10, 4)))], hp[hook(9, EncodeMorton(current + cubeOffsets[5hook(10, 5)))], hp[hook(9, EncodeMorton(current + cubeOffsets[6hook(10, 6)))], hp[hook(9, EncodeMorton(current + cubeOffsets[7hook(10, 7)))],
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

  current += cubeOffsets[hook(10, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}

int4 scanHPLevelChar(int target, global uchar* hp, int4 current) {
  int8 neighbors = {
      hp[hook(9, EncodeMorton(current))], hp[hook(9, EncodeMorton(current + cubeOffsets[1hook(10, 1)))], hp[hook(9, EncodeMorton(current + cubeOffsets[2hook(10, 2)))], hp[hook(9, EncodeMorton(current + cubeOffsets[3hook(10, 3)))], hp[hook(9, EncodeMorton(current + cubeOffsets[4hook(10, 4)))], hp[hook(9, EncodeMorton(current + cubeOffsets[5hook(10, 5)))], hp[hook(9, EncodeMorton(current + cubeOffsets[6hook(10, 6)))], hp[hook(9, EncodeMorton(current + cubeOffsets[7hook(10, 7)))],
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

  current += cubeOffsets[hook(10, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}
int4 scanHPLevelCharNoMorton(int target, global uchar* hp, int4 current, uint3 size) {
  int8 neighbors = {
      hp[hook(9, ((current).x) + ((current).y) * size.x + ((current).z) * size.x * size.y)], hp[hook(9, ((current + cubeOffsets[1hook(10, 1)).x) + ((current + cubeOffsets[1hook(10, 1)).y) * size.x + ((current + cubeOffsets[1hook(10, 1)).z) * size.x * size.y)], hp[hook(9, ((current + cubeOffsets[2hook(10, 2)).x) + ((current + cubeOffsets[2hook(10, 2)).y) * size.x + ((current + cubeOffsets[2hook(10, 2)).z) * size.x * size.y)], hp[hook(9, ((current + cubeOffsets[3hook(10, 3)).x) + ((current + cubeOffsets[3hook(10, 3)).y) * size.x + ((current + cubeOffsets[3hook(10, 3)).z) * size.x * size.y)], hp[hook(9, ((current + cubeOffsets[4hook(10, 4)).x) + ((current + cubeOffsets[4hook(10, 4)).y) * size.x + ((current + cubeOffsets[4hook(10, 4)).z) * size.x * size.y)], hp[hook(9, ((current + cubeOffsets[5hook(10, 5)).x) + ((current + cubeOffsets[5hook(10, 5)).y) * size.x + ((current + cubeOffsets[5hook(10, 5)).z) * size.x * size.y)], hp[hook(9, ((current + cubeOffsets[6hook(10, 6)).x) + ((current + cubeOffsets[6hook(10, 6)).y) * size.x + ((current + cubeOffsets[6hook(10, 6)).z) * size.x * size.y)], hp[hook(9, ((current + cubeOffsets[7hook(10, 7)).x) + ((current + cubeOffsets[7hook(10, 7)).y) * size.x + ((current + cubeOffsets[7hook(10, 7)).z) * size.x * size.y)],
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

  current += cubeOffsets[hook(10, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}

int4 scanHPLevel(int target, global int* hp, int4 current) {
  int8 neighbors = {
      hp[hook(9, EncodeMorton(current))], hp[hook(9, EncodeMorton(current + cubeOffsets[1hook(10, 1)))], hp[hook(9, EncodeMorton(current + cubeOffsets[2hook(10, 2)))], hp[hook(9, EncodeMorton(current + cubeOffsets[3hook(10, 3)))], hp[hook(9, EncodeMorton(current + cubeOffsets[4hook(10, 4)))], hp[hook(9, EncodeMorton(current + cubeOffsets[5hook(10, 5)))], hp[hook(9, EncodeMorton(current + cubeOffsets[6hook(10, 6)))], hp[hook(9, EncodeMorton(current + cubeOffsets[7hook(10, 7)))],
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

  current += cubeOffsets[hook(10, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
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

kernel void splineTDF(read_only image3d_t vectorField, global float* T, private float rMin, private float rMax, private float rStep,

                      private const int arms,

                      global float* R, private const float minAverageMag) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  int invalid = 0;

  const float3 Fx = gradientNormalized(vectorField, pos, 0, 1);
  const float3 Fy = gradientNormalized(vectorField, pos, 1, 2);
  const float3 Fz = gradientNormalized(vectorField, pos, 2, 3);

  float Hessian[3][3] = {{Fx.x, Fy.x, Fz.x}, {Fy.x, Fy.y, Fz.y}, {Fz.x, Fz.y, Fz.z}};

  float eigenValues[3];
  float eigenVectors[3][3];
  eigen_decomposition(Hessian, eigenVectors, eigenValues);
  const float3 e1 = {eigenVectors[hook(12, 0)][hook(11, 0)], eigenVectors[hook(12, 1)][hook(13, 0)], eigenVectors[hook(12, 2)][hook(14, 0)]};
  const float3 e2 = {eigenVectors[hook(12, 0)][hook(11, 1)], eigenVectors[hook(12, 1)][hook(13, 1)], eigenVectors[hook(12, 2)][hook(14, 1)]};
  const float3 e3 = {eigenVectors[hook(12, 0)][hook(11, 2)], eigenVectors[hook(12, 1)][hook(13, 2)], eigenVectors[hook(12, 2)][hook(14, 2)]};

  float currentVoxelMagnitude = length(read_imagef(vectorField, sampler, pos).xyz);

  float maxRadius[12];

  float avgRadius = 0.0f;
  float sum = 0.0f;
  for (int j = 0; j < arms; j++) {
    maxRadius[hook(15, j)] = 999;
    float alpha = 2 * 3.14159265358979323846264338327950288f * j / arms;
    float4 V_alpha = cos(alpha) * e3.xyzz + sin(alpha) * e2.xyzz;
    float prevMagnitude2 = currentVoxelMagnitude;
    float4 position = convert_float4(pos) + rMin * V_alpha;
    float prevMagnitude = length(read_imagef(vectorField, interpolationSampler, position).xyz);
    int up = prevMagnitude2 > prevMagnitude ? 0 : 1;

    for (float radius = rMin + rStep; radius <= rMax; radius += rStep) {
      position = convert_float4(pos) + radius * V_alpha;
      float4 vec = read_imagef(vectorField, interpolationSampler, position);
      vec.w = 0.0f;
      float magnitude = length(vec.xyz);

      if (up == 1 && magnitude < prevMagnitude && (prevMagnitude + magnitude) / 2.0f - currentVoxelMagnitude > minAverageMag) {
        maxRadius[hook(15, j)] = radius;
        avgRadius += radius;
        if (dot(normalize(vec.xyz), -normalize(V_alpha.xyz)) < 0.0f) {
          invalid = 1;
          sum = 0.0f;
        }
        sum += 1.0f - fabs(dot(normalize(vec.xyz), e1));
        break;
      }

      if (magnitude > prevMagnitude) {
        up = 1;
      }
      prevMagnitude = magnitude;
    }

    if (maxRadius[hook(15, j)] == 999 || invalid == 1) {
      invalid = 1;
      break;
    }
  }

  avgRadius = avgRadius / arms;
  R[hook(6, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = avgRadius;
  if (invalid != 1) {
    float avgSymmetry = 0.0f;
    for (int j = 0; j < arms / 2; j++) {
      avgSymmetry += min(maxRadius[hook(15, j)], maxRadius[hook(15, arms / 2 + j)]) / max(maxRadius[hook(15, j)], maxRadius[hook(15, arms / 2 + j)]);
    }
    avgSymmetry /= arms / 2;
    T[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = min(1.0f, (sum / (arms)) * avgSymmetry + 0.2f);
  } else {
    T[hook(1, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = 0;
  }
}