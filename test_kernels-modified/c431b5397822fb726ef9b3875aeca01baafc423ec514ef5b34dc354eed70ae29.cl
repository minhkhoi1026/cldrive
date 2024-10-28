//{"inArray":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef enum { LOGISTIC, RELU, RELIE, LINEAR, RAMP, TANH, PLSE, LEAKY, ELU, LOGGY, STAIR, HARDTAN, LHTAN } ACTIVATION;

kernel void resetarray(global float* inArray) {
  int stepSize = get_local_size(0);
  int index = get_global_id(0) * stepSize;

  int count = 0;

  for (; count < 8; count++)
    inArray[hook(0, index++)] = 0;
}