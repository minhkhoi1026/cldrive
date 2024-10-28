//{"divider":2,"end_idx":3,"input":0,"local_arr":4,"subImg":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void min_max_kernel2(global const float2* input, global float2* subImg, unsigned int divider, const unsigned int end_idx) {
  const unsigned int idx = get_global_id(0);

  const unsigned int first_idx_in = idx * divider;

  if (first_idx_in > end_idx) {
    subImg[hook(1, idx)].x = 0x1.fffffep127f;
    subImg[hook(1, idx)].y = 0x1.0p-126f;
    return;
  }

  if ((first_idx_in + divider) > end_idx)
    divider = end_idx - first_idx_in;

  float2 local_arr[128];

  int j = 0;
  for (int i = first_idx_in; i < (first_idx_in + divider); i++) {
    local_arr[hook(4, j++)] = input[hook(0, i)];
  }

  float min_val = 0x1.fffffep127f;
  float max_val = 0x1.0p-126f;

  for (unsigned int i = 0; i < divider; i++) {
    if (min_val > local_arr[hook(4, i)].x)
      min_val = local_arr[hook(4, i)].x;
    if (max_val < local_arr[hook(4, i)].y)
      max_val = local_arr[hook(4, i)].y;
  }

  subImg[hook(1, idx)].x = min_val;
  subImg[hook(1, idx)].y = max_val;
}