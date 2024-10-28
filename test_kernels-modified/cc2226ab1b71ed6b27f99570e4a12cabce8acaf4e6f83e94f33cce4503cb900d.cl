//{"((__global uchar4 *)final_histo)":9,"((__global uint4 *)global_overflow)":10,"((__global unsigned int *)global_subhisto)":11,"((__global ushort4 *)global_histo)":8,"final_histo":7,"global_histo":5,"global_overflow":6,"global_subhisto":4,"histo_height":2,"histo_width":3,"sm_range_max":1,"sm_range_min":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histo_final_kernel(unsigned int sm_range_min, unsigned int sm_range_max, unsigned int histo_height, unsigned int histo_width, global unsigned int* global_subhisto, global unsigned int* global_histo, global unsigned int* global_overflow, global unsigned int* final_histo) {
  unsigned int blockDimx = get_local_size(0);
  unsigned int gridDimx = get_num_groups(0);
  unsigned int start_offset = get_local_id(0) + get_group_id(0) * blockDimx;
  const ushort4 zero_short = {0, 0, 0, 0};
  const uint4 zero_int = {0, 0, 0, 0};

  unsigned int size_low_histo = sm_range_min * 8;
  unsigned int size_mid_histo = (sm_range_max - sm_range_min + 1) * 8;

  for (unsigned int i = start_offset; i < size_low_histo / 4; i += gridDimx * blockDimx) {
    ushort4 global_histo_data = ((global ushort4*)global_histo)[hook(8, i)];
    ((global ushort4*)global_histo)[hook(8, i)] = zero_short;

    global_histo_data.x = min(global_histo_data.x, (ushort)255);
    global_histo_data.y = min(global_histo_data.y, (ushort)255);
    global_histo_data.z = min(global_histo_data.z, (ushort)255);
    global_histo_data.w = min(global_histo_data.w, (ushort)255);

    uchar4 final_histo_data = (uchar4)((unsigned char)global_histo_data.x, (unsigned char)global_histo_data.y, (unsigned char)global_histo_data.z, (unsigned char)global_histo_data.w);

    ((global uchar4*)final_histo)[hook(9, i)] = final_histo_data;
  }

  for (unsigned int i = (size_low_histo / 4) + start_offset; i < (size_low_histo + size_mid_histo) / 4; i += gridDimx * blockDimx) {
    uint4 global_histo_data = ((global uint4*)global_overflow)[hook(10, i)];
    ((global uint4*)global_overflow)[hook(10, i)] = zero_int;

    uint4 internal_histo_data = (uint4)(global_histo_data.x, global_histo_data.y, global_histo_data.z, global_histo_data.w);

    for (int j = 0; j < 8; j++) {
      unsigned int bin4in = ((global unsigned int*)global_subhisto)[hook(11, i + j * histo_height * histo_width / 4)];
      internal_histo_data.x += (bin4in >> 0) & 0xFF;
      internal_histo_data.y += (bin4in >> 8) & 0xFF;
      internal_histo_data.z += (bin4in >> 16) & 0xFF;
      internal_histo_data.w += (bin4in >> 24) & 0xFF;
    }

    internal_histo_data.x = min(internal_histo_data.x, (unsigned int)255);
    internal_histo_data.y = min(internal_histo_data.y, (unsigned int)255);
    internal_histo_data.z = min(internal_histo_data.z, (unsigned int)255);
    internal_histo_data.w = min(internal_histo_data.w, (unsigned int)255);

    uchar4 final_histo_data = (uchar4)(internal_histo_data.x, internal_histo_data.y, internal_histo_data.z, internal_histo_data.w);

    ((global uchar4*)final_histo)[hook(9, i)] = final_histo_data;
  }

  for (unsigned int i = ((size_low_histo + size_mid_histo) / 4) + start_offset; i < (histo_height * histo_width) / 4; i += gridDimx * blockDimx) {
    ushort4 global_histo_data = ((global ushort4*)global_histo)[hook(8, i)];
    ((global ushort4*)global_histo)[hook(8, i)] = zero_short;

    global_histo_data.x = min(global_histo_data.x, (ushort)255);
    global_histo_data.y = min(global_histo_data.y, (ushort)255);
    global_histo_data.z = min(global_histo_data.z, (ushort)255);
    global_histo_data.w = min(global_histo_data.w, (ushort)255);

    uchar4 final_histo_data = (uchar4)(global_histo_data.x, global_histo_data.y, global_histo_data.z, global_histo_data.w);

    ((global uchar4*)final_histo)[hook(9, i)] = final_histo_data;
  }
}