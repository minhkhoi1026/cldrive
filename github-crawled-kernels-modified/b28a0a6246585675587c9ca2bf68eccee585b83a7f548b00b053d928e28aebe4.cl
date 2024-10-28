//{"constant_key":2,"global_sbox1":3,"global_sbox2":4,"global_sbox3":5,"global_sbox4":6,"input":0,"key":12,"output":1,"sbox1":7,"sbox2":8,"sbox3":9,"sbox4":10,"total_blocks":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void encrypt1(const global uint4* input, global uint4* output, const global uint2* constant_key, const global unsigned int* global_sbox1, const global unsigned int* global_sbox2, const global unsigned int* global_sbox3, const global unsigned int* global_sbox4, local unsigned int* sbox1, local unsigned int* sbox2, local unsigned int* sbox3, local unsigned int* sbox4, unsigned int total_blocks) {
  size_t global_id = get_global_id(0);
  size_t global_size = get_global_size(0);
  size_t local_id = get_local_id(0);
  size_t local_size = get_local_size(0);
  size_t copy_size = 256 / local_size;
  if (copy_size == 0)
    copy_size = 1;
  size_t copy_offset = local_id * copy_size;
  const uint2 shift1 = (uint2)(1);
  const uint2 shift8_uint2 = (uint2)(8);
  const uint2 mask_notfe = (uint2)(~0xfefefefe);
  const uint2 mask_fe = (uint2)(0xfefefefe);
  uint4 t0;
  uint2 x0, x1, s, u;

  if (local_id < 256) {
    for (unsigned int i = 0; i < copy_size; i++) {
      sbox1[hook(7, copy_offset + i)] = global_sbox1[hook(3, copy_offset + i)];
      sbox2[hook(8, copy_offset + i)] = global_sbox2[hook(4, copy_offset + i)];
      sbox3[hook(9, copy_offset + i)] = global_sbox3[hook(5, copy_offset + i)];
      sbox4[hook(10, copy_offset + i)] = global_sbox4[hook(6, copy_offset + i)];
    }
  }
  barrier(0x01);

  for (unsigned int block_idx = global_id; block_idx < total_blocks; block_idx += global_size) {
    const global uint2* key = constant_key;
    t0 = input[hook(0, block_idx)];
    x0 = t0.s01 ^ key[hook(12, 0)];
    x1 = t0.s23 ^ key[hook(12, 1)];
    key += 2;

    for (int l = 0;; l++) {
      for (unsigned int i = 0; i < 3; i++) {
        s = x0 ^ key[hook(12, 0)];
        u = (uint2)(sbox1[hook(7, s.s0 & 255)], sbox2[hook(8, s.s1 & 255)]);
        s = s >> shift8_uint2;
        u ^= (uint2)(sbox2[hook(8, s.s0 & 255)], sbox3[hook(9, s.s1 & 255)]);
        s = s >> shift8_uint2;
        u ^= (uint2)(sbox3[hook(9, s.s0 & 255)], sbox4[hook(10, s.s1 & 255)]);
        s = s >> shift8_uint2;
        u ^= (uint2)(sbox4[hook(10, s.s0)], sbox1[hook(7, s.s1)]);
        x1 ^= (uint2)(u.s0 ^ u.s1, u.s0 ^ u.s1 ^ ((u.s0 << 8) | (u.s0 >> 24)));

        s = x1 ^ key[hook(12, 1)];
        u = (uint2)(sbox1[hook(7, s.s0 & 255)], sbox2[hook(8, s.s1 & 255)]);
        s = s >> shift8_uint2;
        u ^= (uint2)(sbox2[hook(8, s.s0 & 255)], sbox3[hook(9, s.s1 & 255)]);
        s = s >> shift8_uint2;
        u ^= (uint2)(sbox3[hook(9, s.s0 & 255)], sbox4[hook(10, s.s1 & 255)]);
        s = s >> shift8_uint2;
        u ^= (uint2)(sbox4[hook(10, s.s0 & 255)], sbox1[hook(7, s.s1 & 255)]);
        x0 ^= (uint2)(u.s0 ^ u.s1, u.s0 ^ u.s1 ^ ((u.s0 << 8) | (u.s0 >> 24)));
        key += 2;
      }
      if (l == 2)
        break;

      x1.s0 ^= x1.s1 | key[hook(12, 1)].s1;
      u = (uint2)(x0.s0 & key[hook(12, 0)].s0, x1.s0 & key[hook(12, 1)].s0);
      u = ((u << shift1) & mask_fe) | ((((u) << (uint2)(17)) | ((u) >> (uint2)(32 - 17))) & mask_notfe);
      x0.s1 ^= u.s0;
      x0.s0 ^= x0.s1 | key[hook(12, 0)].s1;
      x1.s1 ^= u.s1;
      key += 2;
    }

    x0 ^= key[hook(12, 1)];
    x1 ^= key[hook(12, 0)];
    output[hook(1, block_idx)] = (uint4)(x1.s0, x1.s1, x0.s0, x0.s1);
  }
}