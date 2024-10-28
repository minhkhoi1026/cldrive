//{"C":1,"cubeOffsets":5,"cubeOffsets2D":4,"edges":0,"m":2,"sum":3}
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

  current += cubeOffsets2D[hook(4, (cmp.s0 + cmp.s1 + cmp.s2))].xyz;
  current.x = current.x * 2;
  current.y = current.y * 2;
  current.z = current.z + cmp.s0 * neighbors.s0 + cmp.s1 * neighbors.s1 + cmp.s2 * neighbors.s2;
  return current;
}

int4 scanHPLevel3D(int target, read_only image3d_t hp, int4 current) {
  int8 neighbors = {read_imagei(hp, hpSampler, current).x, read_imagei(hp, hpSampler, current + cubeOffsets[hook(5, 1)]).x, read_imagei(hp, hpSampler, current + cubeOffsets[hook(5, 2)]).x, read_imagei(hp, hpSampler, current + cubeOffsets[hook(5, 3)]).x, read_imagei(hp, hpSampler, current + cubeOffsets[hook(5, 4)]).x, read_imagei(hp, hpSampler, current + cubeOffsets[hook(5, 5)]).x, read_imagei(hp, hpSampler, current + cubeOffsets[hook(5, 6)]).x, 0};

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

  current += cubeOffsets[hook(5, (cmp.s0 + cmp.s1 + cmp.s2 + cmp.s3 + cmp.s4 + cmp.s5 + cmp.s6))];
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

kernel void graphComponentLabeling(global int const* restrict edges, volatile global int* C, global int* m, private int sum) {
  int id = get_global_id(0);
  if (id >= sum)
    id = 0;
  int2 edge = vload2(id, edges);
  const int ca = C[hook(1, edge.x)];
  const int cb = C[hook(1, edge.y)];

  if (ca == cb) {
    return;
  } else {
    if (ca < cb) {
      volatile int i = atomic_min(&C[hook(1, edge.y)], ca);
    } else {
      volatile int i = atomic_min(&C[hook(1, edge.x)], cb);
    }
    m[hook(2, 0)] = 1;
  }
}