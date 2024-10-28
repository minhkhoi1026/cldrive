//{"divider":2,"input":0,"local_arr":3,"subImg":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void min_max_kernel(global const float* input, global float2* subImg, const unsigned int divider) {
  const unsigned int idx = get_global_id(0);

  const unsigned int first_idx_in = idx * divider;

  float local_arr[128];

  int j = 0;
  for (int i = first_idx_in; i < (first_idx_in + divider); i++) {
    local_arr[hook(3, j++)] = input[hook(0, i)];
  }

  float min_val = 0x1.fffffep127f;
  float max_val = 0x1.0p-126f;

  for (int i = 0; i < divider; i++) {
    if (min_val > local_arr[hook(3, i)])
      min_val = local_arr[hook(3, i)];
    if (max_val < local_arr[hook(3, i)])
      max_val = local_arr[hook(3, i)];
  }

  subImg[hook(1, idx)].x = min_val;
  subImg[hook(1, idx)].y = max_val;
}