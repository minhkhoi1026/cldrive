//{"actions":4,"discountFactor":8,"enabled":2,"index":7,"isTerminalStates":5,"output":0,"rewards":3,"size":6,"values":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_teaching_input(global const float* output, global float* values, global char* enabled, global const float* rewards, global const int* actions, global const char* isTerminalStates, unsigned int size, unsigned int index, float discountFactor) {
  int inputIndex = actions[hook(4, index)];
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    if (i != inputIndex) {
      enabled[hook(2, i)] = 0;
    } else {
      enabled[hook(2, i)] = 1;
      values[hook(1, i)] = rewards[hook(3, index)];

      if (!isTerminalStates[hook(5, index)]) {
        int bestOutput = 0;
        for (unsigned int j = 1; j < size; j++) {
          if (output[hook(0, bestOutput)] <= output[hook(0, j)])
            bestOutput = j;
        }
        values[hook(1, i)] += discountFactor * output[hook(0, bestOutput)];
      }
    }
  }
}