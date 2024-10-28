//{"biases":1,"n":2,"output":0,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef enum { LOGISTIC, RELU, RELIE, LINEAR, RAMP, TANH, PLSE, LEAKY, ELU, LOGGY, STAIR, HARDTAN, LHTAN } ACTIVATION;

kernel void scalebias(global float* output, global float* biases, int n, int size) {
  int offset = get_global_id(0);
  int filter = get_group_id(1);

  output[hook(0, filter * size + offset)] *= biases[hook(1, filter)];
}