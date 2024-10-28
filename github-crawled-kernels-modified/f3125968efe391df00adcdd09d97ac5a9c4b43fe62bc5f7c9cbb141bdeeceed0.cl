//{"input":0,"input_size":1,"output":2,"output_size":3,"private_buffer":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square(global float* input, const unsigned int input_size, global float* output, const unsigned int output_size) {
  int range_start = get_global_id(0) * 64;
  int range_end = range_start + 64;

 private
  float private_buffer[128];

  for (int i = range_start; i < range_end; i++) {
   private
    float orig_input = input[hook(0, i)];

    for (int j = 0; j < 128; j++) {
      private_buffer[hook(4, j)] = orig_input + j;
    }

   private
    float* forward_iter = &private_buffer[hook(4, 0)];
   private
    float* reverse_iter = &private_buffer[hook(4, 128 - 1)];
   private
    float result = 0;
   private
    float temp = 0;
    for (int j = 0; j < 128; j++) {
      temp = *forward_iter;
      result += temp;
      temp = *reverse_iter;
      result -= temp;
      forward_iter++;
      reverse_iter--;
    }

    result = (float)((int)(result > 0 ? result : -result));
    result += orig_input;
    output[hook(2, i)] = result * result;
  }
}