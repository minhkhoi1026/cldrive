//{"dimensions":1,"hypotheses":0,"number_of_images":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calculate_number_of_consistent_hypotheses_by_voxels(global uchar* hypotheses, global const unsigned int* dimensions, unsigned int number_of_images) {
  uint4 voxel_pos = (uint4)(get_global_id(0), get_global_id(1), get_global_id(2), 0);

  unsigned int hypothesis_offset = voxel_pos.x * (1 + number_of_images) + voxel_pos.y * dimensions[hook(1, 0)] * (1 + number_of_images) + voxel_pos.z * dimensions[hook(1, 0)] * dimensions[hook(1, 1)] * (1 + number_of_images);

  uchar4 voxel_info = vload4(hypothesis_offset, hypotheses);
  if (voxel_info.x == 0)
    return;

  uchar consistent_hypotheses = 0;

  for (unsigned int i = 0; i < number_of_images; ++i) {
    uchar4 float3 = vload4(hypothesis_offset + 1 + i, hypotheses);

    if ((float3.x + float3.y + float3.z + float3.w) != 0)
      consistent_hypotheses++;
  }

  if (consistent_hypotheses == 0) {
    vstore4((uchar4)(0), hypothesis_offset, hypotheses);
  } else if (voxel_info.y != consistent_hypotheses) {
    voxel_info.y = consistent_hypotheses;
    vstore4(voxel_info, hypothesis_offset, hypotheses);
  }
}