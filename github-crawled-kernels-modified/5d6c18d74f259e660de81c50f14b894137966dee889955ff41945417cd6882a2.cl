//{"TDF":0,"compacted_lengths":3,"cubeOffsets":8,"cubeOffsets2D":7,"edges":2,"maxDistance":6,"minAvgTDF":5,"positions":1,"sum":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
constant sampler_t interpolationSampler = 0 | 2 | 0x20;
constant sampler_t hpSampler = 0 | 4 | 0x10;
constant int4 cubeOffsets2D[4] = {
    {0, 0, 0, 0},
    {0, 1, 0, 0},
    {1, 0, 0, 0},
    {1, 1, 0, 0},
};

constant int4 cubeOffsets[8] = {
    {0, 0, 0, 0}, {1, 0, 0, 0}, {0, 0, 1, 0}, {1, 0, 1, 0}, {0, 1, 0, 0}, {1, 1, 0, 0}, {0, 1, 1, 0}, {1, 1, 1, 0},
};

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

int4 scanHPLevel3D(int target, read_only image3d_t hp, int4 current) {
  int8 neighbors = {read_imagei(hp, hpSampler, current).x, read_imagei(hp, hpSampler, current + cubeOffsets[hook(8, 1)]).x, read_imagei(hp, hpSampler, current + cubeOffsets[hook(8, 2)]).x, read_imagei(hp, hpSampler, current + cubeOffsets[hook(8, 3)]).x, read_imagei(hp, hpSampler, current + cubeOffsets[hook(8, 4)]).x, read_imagei(hp, hpSampler, current + cubeOffsets[hook(8, 5)]).x, read_imagei(hp, hpSampler, current + cubeOffsets[hook(8, 6)]).x, 0};

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

  current += cubeOffsets[hook(8, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6))];
  current.s0 = current.s0 * 2;
  current.s1 = current.s1 * 2;
  current.s2 = current.s2 * 2;
  current.s3 = current.s3 + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2 + cmp.s3 * neighbors.s3 + cmp.s4 * neighbors.s4 + cmp.s5 * neighbors.s5 + cmp.s6 * neighbors.s6;
  return current;
}

int4 traverseHP3D(int target, int HP_SIZE, image3d_t hp0, image3d_t hp1, image3d_t hp2, image3d_t hp3, image3d_t hp4, image3d_t hp5, image3d_t hp6, image3d_t hp7, image3d_t hp8, image3d_t hp9) {
  int4 position = {0, 0, 0, 0};
  if (HP_SIZE > 512)
    position = scanHPLevel3D(target, hp9, position);
  if (HP_SIZE > 256)
    position = scanHPLevel3D(target, hp8, position);
  if (HP_SIZE > 128)
    position = scanHPLevel3D(target, hp7, position);
  if (HP_SIZE > 64)
    position = scanHPLevel3D(target, hp6, position);
  if (HP_SIZE > 32)
    position = scanHPLevel3D(target, hp5, position);
  if (HP_SIZE > 16)
    position = scanHPLevel3D(target, hp4, position);
  if (HP_SIZE > 8)
    position = scanHPLevel3D(target, hp3, position);
  position = scanHPLevel3D(target, hp2, position);
  position = scanHPLevel3D(target, hp1, position);
  position = scanHPLevel3D(target, hp0, position);
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

      if (db + dc < shortestDistance) {
        float3 ab = (xb - xa);
        float3 ac = (xc - xa);
        float angle = acos(dot(normalize(ab), normalize(ac)));

        if (angle < 2.0f)

          continue;

        float avgTDF = 0.0f;
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
    write_imagei(edges, edge, 1);
    write_imagei(edges, edge2, 1);
  }
}