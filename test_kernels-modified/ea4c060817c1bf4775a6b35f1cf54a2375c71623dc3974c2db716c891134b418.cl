//{"input":0,"input_len":2,"output":1,"start":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arg_max(global float* input, global unsigned int* output, const unsigned int input_len, const unsigned int start) {
  const unsigned int t = (start + get_group_id(0) * get_local_size(0) + get_local_id(0)) * 10;
  if (t < input_len) {
    unsigned int max_idx = 0;
    float max = input[hook(0, t)];
    for (unsigned int i = 1; i < 10; i++) {
      const float temp = input[hook(0, t + i)];
      if (temp > max) {
        max = temp;
        max_idx = i;
      }
    }
    output[hook(1, t / 10)] = max_idx;
  }
}