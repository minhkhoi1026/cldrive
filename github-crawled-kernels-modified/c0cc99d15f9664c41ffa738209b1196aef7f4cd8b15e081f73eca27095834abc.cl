//{"inputData":0,"outputData":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void offsetAccumulateElements(global const unsigned int* inputData, global unsigned int* outputData) {
  unsigned int data;
  uint4 dataExpanded = (uint4)(0u, 0u, 0u, 0u);
  uint4 temp;

  unsigned int address = get_local_id(0) + get_group_id(1) * 64u;

  if (address * 8u + 7u < 64 * 4 * 2u) {
    address += get_group_id(2) * 1 * (64 * 4 / 4u);

    for (int i = 0; i < 1; i++) {
      data = inputData[hook(0, address)];

      temp.s0 = ((data & 0x000000f0) << 12u) | ((data & 0x0000000f) >> 0u);
      temp.s1 = ((data & 0x0000f000) << 4u) | ((data & 0x00000f00) >> 8u);
      temp.s2 = ((data & 0x00f00000) >> 4u) | ((data & 0x000f0000) >> 16u);
      temp.s3 = ((data & 0xf0000000) >> 12u) | ((data & 0x0f000000) >> 24u);

      dataExpanded += temp;

      address += (64 * 4 / 4u);
    }

    address = (get_local_id(0) + get_group_id(1) * 64u) * 8u;
    atomic_add(&outputData[hook(1, address + 0U)], (dataExpanded.s0 >> 16));
    atomic_add(&outputData[hook(1, address + 1U)], (dataExpanded.s0 & 0x0000ffff));
    atomic_add(&outputData[hook(1, address + 2U)], (dataExpanded.s1 >> 16));
    atomic_add(&outputData[hook(1, address + 3U)], (dataExpanded.s1 & 0x0000ffff));
    atomic_add(&outputData[hook(1, address + 4U)], (dataExpanded.s2 >> 16));
    atomic_add(&outputData[hook(1, address + 5U)], (dataExpanded.s2 & 0x0000ffff));
    atomic_add(&outputData[hook(1, address + 6U)], (dataExpanded.s3 >> 16));
    atomic_add(&outputData[hook(1, address + 7U)], (dataExpanded.s3 & 0x0000ffff));
  }
}