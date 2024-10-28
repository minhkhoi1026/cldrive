//{"dimensions":2,"hypotheses":0,"number_of_images":3,"voxel_model":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void build_voxel_model(global uchar* hypotheses, global uchar* voxel_model, global const unsigned int* dimensions, unsigned int number_of_images) {
  uint4 pos = (uint4)(get_global_id(0), get_global_id(1), get_global_id(2), 0);

  const unsigned int hypothesis_offset = pos.x * (1 + number_of_images) + pos.y * dimensions[hook(2, 0)] * (1 + number_of_images) + pos.z * dimensions[hook(2, 0)] * dimensions[hook(2, 1)] * (1 + number_of_images);

  uint4 result_color = (uint4)(0);
  unsigned int result_number_of_hypotheses = 0;

  uchar4 voxel_info = vload4(hypothesis_offset, hypotheses);

  if (voxel_info.x != 0) {
    for (unsigned int i = 0; i < number_of_images; ++i) {
      uchar4 float3 = vload4(hypothesis_offset + 1 + i, hypotheses);

      if ((float3.x + float3.y + float3.z + float3.w) != 0) {
        result_color.x += float3.x;
        result_color.y += float3.y;
        result_color.z += float3.z;
        result_color.w += float3.w;
        result_number_of_hypotheses++;
      }
    }

    result_color /= result_number_of_hypotheses;

    vstore4((uchar4)(0, result_color.x, result_color.y, result_color.z), pos.x + pos.y * dimensions[hook(2, 0)] + pos.z * dimensions[hook(2, 0)] * dimensions[hook(2, 1)], voxel_model);
  } else
    vstore4((uchar4)(0, 0, 0, 0), pos.x + pos.y * dimensions[hook(2, 0)] + pos.z * dimensions[hook(2, 0)] * dimensions[hook(2, 1)], voxel_model);
}