//{"biases":1,"n":2,"output":0,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef enum { LOGISTIC, RELU, RELIE, LINEAR, RAMP, TANH, PLSE, LEAKY, ELU, LOGGY, STAIR, HARDTAN, LHTAN } ACTIVATION;

kernel void addbias(global float* output, global float* biases, int n, int size) {
  int filter = get_group_id(1);
  int stepSize = get_local_size(0);
  int offset = get_global_id(0) * stepSize;

  local float biasesFilt;
  biasesFilt = biases[hook(1, filter)];

  float8 localOutput = vload8(0, &output[hook(0, filter * size + offset)]);
  localOutput += biasesFilt;
  vstore8(localOutput, 0, &output[hook(0, filter * size + offset)]);
}