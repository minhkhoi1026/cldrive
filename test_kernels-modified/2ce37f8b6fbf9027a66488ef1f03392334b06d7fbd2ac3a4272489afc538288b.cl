//{"TDF":0,"compacted_lengths":3,"cubeOffsets":9,"cubeOffsets2D":7,"edges":2,"hp":8,"maxDistance":6,"minAvgTDF":5,"positions":1,"sum":4}
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

  current += cubeOffsets2D[hook(7, (cmp.s0 + cmp.s1 + cmp.s2))].xyz;
  current.x = current.x * 2;
  current.y = current.y * 2;
  current.z = current.z + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2;
  return current;
}

int4 scanHPLevelShort(int target, global ushort* hp, int4 current) {
  int8 neighbors = {
      hp[hook(8, EncodeMorton(current))], hp[hook(8, EncodeMorton(current + cubeOffsets[1hook(9, 1)))], hp[hook(8, EncodeMorton(current + cubeOffsets[2hook(9, 2)))], hp[hook(8, EncodeMorton(current + cubeOffsets[3hook(9, 3)))], hp[hook(8, EncodeMorton(current + cubeOffsets[4hook(9, 4)))], hp[hook(8, EncodeMorton(current + cubeOffsets[5hook(9, 5)))], hp[hook(8, EncodeMorton(current + cubeOffsets[6hook(9, 6)))], hp[hook(8, EncodeMorton(current + cubeOffsets[7hook(9, 7)))],
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

  current += cubeOffsets[hook(9, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}

int4 scanHPLevelChar(int target, global uchar* hp, int4 current) {
  int8 neighbors = {
      hp[hook(8, EncodeMorton(current))], hp[hook(8, EncodeMorton(current + cubeOffsets[1hook(9, 1)))], hp[hook(8, EncodeMorton(current + cubeOffsets[2hook(9, 2)))], hp[hook(8, EncodeMorton(current + cubeOffsets[3hook(9, 3)))], hp[hook(8, EncodeMorton(current + cubeOffsets[4hook(9, 4)))], hp[hook(8, EncodeMorton(current + cubeOffsets[5hook(9, 5)))], hp[hook(8, EncodeMorton(current + cubeOffsets[6hook(9, 6)))], hp[hook(8, EncodeMorton(current + cubeOffsets[7hook(9, 7)))],
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

  current += cubeOffsets[hook(9, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}
int4 scanHPLevelCharNoMorton(int target, global uchar* hp, int4 current, uint3 size) {
  int8 neighbors = {
      hp[hook(8, ((current).x) + ((current).y) * size.x + ((current).z) * size.x * size.y)], hp[hook(8, ((current + cubeOffsets[1hook(9, 1)).x) + ((current + cubeOffsets[1hook(9, 1)).y) * size.x + ((current + cubeOffsets[1hook(9, 1)).z) * size.x * size.y)], hp[hook(8, ((current + cubeOffsets[2hook(9, 2)).x) + ((current + cubeOffsets[2hook(9, 2)).y) * size.x + ((current + cubeOffsets[2hook(9, 2)).z) * size.x * size.y)], hp[hook(8, ((current + cubeOffsets[3hook(9, 3)).x) + ((current + cubeOffsets[3hook(9, 3)).y) * size.x + ((current + cubeOffsets[3hook(9, 3)).z) * size.x * size.y)], hp[hook(8, ((current + cubeOffsets[4hook(9, 4)).x) + ((current + cubeOffsets[4hook(9, 4)).y) * size.x + ((current + cubeOffsets[4hook(9, 4)).z) * size.x * size.y)], hp[hook(8, ((current + cubeOffsets[5hook(9, 5)).x) + ((current + cubeOffsets[5hook(9, 5)).y) * size.x + ((current + cubeOffsets[5hook(9, 5)).z) * size.x * size.y)], hp[hook(8, ((current + cubeOffsets[6hook(9, 6)).x) + ((current + cubeOffsets[6hook(9, 6)).y) * size.x + ((current + cubeOffsets[6hook(9, 6)).z) * size.x * size.y)], hp[hook(8, ((current + cubeOffsets[7hook(9, 7)).x) + ((current + cubeOffsets[7hook(9, 7)).y) * size.x + ((current + cubeOffsets[7hook(9, 7)).z) * size.x * size.y)],
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

  current += cubeOffsets[hook(9, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6 + cmp.s7 * neighbors.s7;
  return current;
}

int4 scanHPLevel(int target, global int* hp, int4 current) {
  int8 neighbors = {
      hp[hook(8, EncodeMorton(current))], hp[hook(8, EncodeMorton(current + cubeOffsets[1hook(9, 1)))], hp[hook(8, EncodeMorton(current + cubeOffsets[2hook(9, 2)))], hp[hook(8, EncodeMorton(current + cubeOffsets[3hook(9, 3)))], hp[hook(8, EncodeMorton(current + cubeOffsets[4hook(9, 4)))], hp[hook(8, EncodeMorton(current + cubeOffsets[5hook(9, 5)))], hp[hook(8, EncodeMorton(current + cubeOffsets[6hook(9, 6)))], hp[hook(8, EncodeMorton(current + cubeOffsets[7hook(9, 7)))],
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

  current += cubeOffsets[hook(9, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6 + cmp.s7))];
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

kernel void linkCenterpoints(read_only image3d_t TDF, global int const* restrict positions, write_only image2d_t edges, read_only image2d_t compacted_lengths, private int sum, private float minAvgTDF, private float maxDistance) {
  int id = get_global_id(0);
  if (id >= sum)
    id = 0;
  float3 xa = convert_float3(vload3(id, positions));

  int2 bestPair;
  float shortestDistance = maxDistance * 2;
  bool validPairFound = false;
  for (int i = 0; i < sum; i++) {
    float2 cl = read_imagef(compacted_lengths, sampler, (int2)(id, i)).xy;

    if (cl.x == 0.0f)
      break;

    float3 xb = convert_float3(vload3(cl.y, positions));
    int db = round(cl.x);
    if (db >= shortestDistance)
      continue;
    for (int j = 0; j < i; j++) {
      float2 cl2 = read_imagef(compacted_lengths, sampler, (int2)(id, j)).xy;
      if (cl2.y == cl.y)
        continue;

      if (cl2.x == 0.0f)
        break;
      float3 xc = convert_float3(vload3(cl2.y, positions));

      int dc = round(cl2.x);

      float minTDF = 0.0f;
      float maxVarTDF = 1.005f;
      float maxIntensity = 1.3f;
      float maxAvgIntensity = 1.2f;
      float maxVarIntensity = 1.005f;

      if (db + dc < shortestDistance) {
        float3 ab = (xb - xa);
        float3 ac = (xc - xa);
        float angle = acos(dot(normalize(ab), normalize(ac)));
        if (angle < 2.0f)
          continue;

        float avgTDF = 0.0f;
        float avgIntensity = 0.0f;
        for (int k = 0; k <= db; k++) {
          float alpha = (float)k / db;
          float3 p = xa + ab * alpha;
          float t = read_imagef(TDF, interpolationSampler, p.xyzz).x;
          avgTDF += t;
        }
        avgTDF /= db + 1;
        if (avgTDF < minAvgTDF)
          continue;
        avgTDF = 0.0f;
        for (int k = 0; k <= dc; k++) {
          float alpha = (float)k / dc;
          float3 p = xa + ac * alpha;
          float t = read_imagef(TDF, interpolationSampler, p.xyzz).x;
          avgTDF += t;
        }
        avgTDF /= dc + 1;

        if (avgTDF < minAvgTDF)
          continue;
        validPairFound = true;
        bestPair.x = cl.y;
        bestPair.y = cl2.y;
        shortestDistance = db + dc;
      }
    }
  }

  if (validPairFound) {
    int2 edge = {id, bestPair.x};
    int2 edge2 = {id, bestPair.y};
    write_imageui(edges, edge, (uint4)(1, 0, 0, 0));
    write_imageui(edges, edge2, (uint4)(1, 0, 0, 0));
  }
}