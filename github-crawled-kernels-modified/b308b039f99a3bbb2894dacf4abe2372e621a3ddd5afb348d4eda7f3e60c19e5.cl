//{"biases":2,"n":3,"output":0,"scales":1,"size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef enum { LOGISTIC, RELU, RELIE, LINEAR, RAMP, TANH, PLSE, LEAKY, ELU, LOGGY, STAIR, HARDTAN, LHTAN } ACTIVATION;

kernel void scaleaddbias(global float* output, global float* scales, global float* biases, int n, int size) {
  int filter = get_group_id(1);
  int stepSize = get_local_size(0);
  int offset = get_global_id(0) * stepSize;
  int count = 0;

  for (; count < 8; count++)
    output[hook(0, filter * size + (offset++))] = output[hook(0, filter * size + offset)] * scales[hook(1, filter)] + biases[hook(2, filter)];
}