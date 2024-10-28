//{"biases":1,"output":0,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef enum { LOGISTIC, RELU, RELIE, LINEAR, RAMP, TANH, PLSE, LEAKY, ELU, LOGGY, STAIR, HARDTAN, LHTAN } ACTIVATION;

kernel void resetarray(global float* output, global float* biases, int size) {
  int filter = get_group_id(1);
  int resetStepSize = get_local_size(0);
  int offset = get_global_id(0) * resetStepSize;
  float8 localOutput = (float8)0;
  vstore8(localOutput, 0, &output[hook(0, offset)]);
}