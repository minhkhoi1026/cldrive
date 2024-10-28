//{"block":2,"input":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixTranspose(global float4* output, global float4* input, local float4* block) {
  unsigned int wiWidth = get_global_size(0);

  unsigned int gix_t = get_group_id(0);
  unsigned int giy_t = get_group_id(1);

  unsigned int num_of_blocks_x = get_num_groups(0);

  unsigned int giy = gix_t;
  unsigned int gix = (gix_t + giy_t) % num_of_blocks_x;

  unsigned int lix = get_local_id(0);
  unsigned int liy = get_local_id(1);

  unsigned int blockSize = get_local_size(0);

  unsigned int ix = gix * blockSize + lix;
  unsigned int iy = giy * blockSize + liy;
  int index_in = ix + (iy)*wiWidth * 4;

  int ind = liy * blockSize * 4 + lix;
  block[hook(2, ind)] = input[hook(1, index_in)];
  block[hook(2, ind + blockSize)] = input[hook(1, index_in + wiWidth)];
  block[hook(2, ind + blockSize * 2)] = input[hook(1, index_in + wiWidth * 2)];
  block[hook(2, ind + blockSize * 3)] = input[hook(1, index_in + wiWidth * 3)];

  barrier(0x01);

  ix = giy * blockSize + lix;
  iy = gix * blockSize + liy;
  int index_out = ix + (iy)*wiWidth * 4;

  ind = lix * blockSize * 4 + liy;
  float4 v0 = block[hook(2, ind)];
  float4 v1 = block[hook(2, ind + blockSize)];
  float4 v2 = block[hook(2, ind + blockSize * 2)];
  float4 v3 = block[hook(2, ind + blockSize * 3)];

  output[hook(0, index_out)] = (float4)(v0.x, v1.x, v2.x, v3.x);
  output[hook(0, index_out + wiWidth)] = (float4)(v0.y, v1.y, v2.y, v3.y);
  output[hook(0, index_out + wiWidth * 2)] = (float4)(v0.z, v1.z, v2.z, v3.z);
  output[hook(0, index_out + wiWidth * 3)] = (float4)(v0.w, v1.w, v2.w, v3.w);
}