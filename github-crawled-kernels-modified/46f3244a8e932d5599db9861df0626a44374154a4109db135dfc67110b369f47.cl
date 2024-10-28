//{"T0":8,"T1":9,"T3":11,"float2":10,"global_T0":3,"global_T1":4,"global_T2":5,"global_T3":6,"global_sbox":7,"input":0,"key":2,"output":1,"sbox":12,"total_blocks":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void encrypt3(const global uint4* input, global uint4* output, const global uint4 key[11], const global unsigned int global_T0[256], const global unsigned int global_T1[256], const global unsigned int global_T2[256], const global unsigned int global_T3[256], const global unsigned int global_sbox[256], local unsigned int T0[256], local unsigned int T1[256], local unsigned int float2[256], local unsigned int T3[256], local unsigned int sbox[256], unsigned int total_blocks) {
  size_t global_id = get_global_id(0);
  size_t global_size = get_global_size(0);
  size_t local_id = get_local_id(0);
  size_t local_size = get_local_size(0);
  size_t t0_copy_size = 256 / local_size;
  if (t0_copy_size == 0)
    t0_copy_size = 1;
  size_t t0_copy_offset = local_id * t0_copy_size;
  const uint4 shift_8 = (uint4)(8);
  const uint4 mask_0 = (uint4)(0x00ff00ff);
  const uint4 mask_1 = (uint4)(0xff00ff00);
  uint4 t0, t1;

  if (local_id < 256) {
    for (unsigned int i = 0; i < t0_copy_size; i++) {
      T0[hook(8, t0_copy_offset + i)] = global_T0[hook(3, t0_copy_offset + i)];
      T1[hook(9, t0_copy_offset + i)] = global_T1[hook(4, t0_copy_offset + i)];
      float2[hook(10, t0_copy_offset + i)] = global_T2[hook(5, t0_copy_offset + i)];
      T3[hook(11, t0_copy_offset + i)] = global_T3[hook(6, t0_copy_offset + i)];
      sbox[hook(12, t0_copy_offset + i)] = global_sbox[hook(7, t0_copy_offset + i)];
    }
  }
  barrier(0x01);

  for (unsigned int block_idx = global_id; block_idx < total_blocks; block_idx += global_size) {
    t1 = input[hook(0, block_idx)];
    t0 = (((((t1) << (uint4)(8)) | ((t1) >> (uint4)(32 - (8)))) & mask_0) | ((((t1) << (uint4)(24)) | ((t1) >> (uint4)(32 - (24)))) & mask_1)) ^ key[hook(2, 0)];

    for (int i = 1; i <= 9; i++) {
      t1 = (uint4)(T3[hook(11, t0.s3 & 255)], T3[hook(11, t0.s0 & 255)], T3[hook(11, t0.s1 & 255)], T3[hook(11, t0.s2 & 255)]);
      t0 = t0 >> shift_8;
      t1 ^= (uint4)(float2[hook(10, t0.s2 & 255)], float2[hook(10, t0.s3 & 255)], float2[hook(10, t0.s0 & 255)], float2[hook(10, t0.s1 & 255)]);
      t0 = t0 >> shift_8;
      t1 ^= (uint4)(T1[hook(9, t0.s1 & 255)], T1[hook(9, t0.s2 & 255)], T1[hook(9, t0.s3 & 255)], T1[hook(9, t0.s0 & 255)]);
      t0 = t0 >> shift_8;
      t0 = t1 ^ (uint4)(T0[hook(8, t0.s0)], T0[hook(8, t0.s1)], T0[hook(8, t0.s2)], T0[hook(8, t0.s3)]) ^ key[hook(2, i)];
    }

    t1 = (uint4)(sbox[hook(12, t0.s3 & 255)], sbox[hook(12, t0.s0 & 255)], sbox[hook(12, t0.s1 & 255)], sbox[hook(12, t0.s2 & 255)]) << shift_8;
    t0 = t0 >> shift_8;
    t1 = (t1 | (uint4)(sbox[hook(12, t0.s2 & 255)], sbox[hook(12, t0.s3 & 255)], sbox[hook(12, t0.s0 & 255)], sbox[hook(12, t0.s1 & 255)])) << shift_8;
    t0 = t0 >> shift_8;
    t1 = (t1 | (uint4)(sbox[hook(12, t0.s1 & 255)], sbox[hook(12, t0.s2 & 255)], sbox[hook(12, t0.s3 & 255)], sbox[hook(12, t0.s0 & 255)])) << shift_8;
    t0 = t0 >> shift_8;
    output[hook(1, block_idx)] = (t1 | (uint4)(sbox[hook(12, t0.s0)], sbox[hook(12, t0.s1)], sbox[hook(12, t0.s2)], sbox[hook(12, t0.s3)])) ^ key[hook(2, 10)];
  }
}