//{"dimensions":4,"hypotheses":0,"threshold":5,"x":1,"y":2,"z":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initial_inconsistent_hypotheses_rejection(global uchar* hypotheses, unsigned int x, unsigned int y, unsigned int z, global const unsigned int* dimensions, float threshold) {
  unsigned int pos = get_global_id(0);

  unsigned int number_of_images = get_global_size(0);

  const unsigned int hypotheses_offset = x * (1 + number_of_images) + y * dimensions[hook(4, 0)] * (1 + number_of_images) + z * dimensions[hook(4, 0)] * dimensions[hook(4, 1)] * (1 + number_of_images);

  uchar4 voxel_info = vload4(hypotheses_offset, hypotheses);
  if (voxel_info.x == 0)
    return;

  uchar4 hypothesis_color = vload4(hypotheses_offset + 1 + pos, hypotheses);

  if ((hypothesis_color.x + hypothesis_color.y + hypothesis_color.z + hypothesis_color.w) == 0)
    return;

  unsigned int consistent = 0;
  for (unsigned int i = 0; i < number_of_images && consistent == 0; ++i) {
    unsigned int current_offset = hypotheses_offset + 1 + i;

    if (i != pos) {
      uchar4 float3 = vload4(current_offset, hypotheses);

      if (isless(distance(normalize(convert_float4(float3)), normalize(convert_float4(hypothesis_color))), threshold))
        consistent = 1;
    }
  }

  if (consistent == 0) {
    vstore4((uchar4)(0), hypotheses_offset + 1 + pos, hypotheses);
  }
}