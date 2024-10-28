//{"batchSize":9,"doutp":1,"dparams":0,"inp":3,"numMovies":6,"numUsers":5,"outp":2,"params":4,"vectorWidthMovie":7,"vectorWidthUser":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float atomic_add(volatile global float* address, const float value) {
  float old = value;
  while ((old = atomic_xchg(address, atomic_xchg(address, 0.0f) + old)) != 0.0f)
    ;
  return old;
}

kernel void movieuser_backward(global float* dparams, global float* doutp, global float* outp, global int* inp, global float* params, int numUsers, int numMovies, int vectorWidthMovie, int vectorWidthUser, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    int m = inp[hook(3, 2 * tid)];
    int u = inp[hook(3, 2 * tid + 1)];

    for (int i = 0; i < vectorWidthMovie; i++) {
      atomic_add(&(dparams[hook(0, m * vectorWidthMovie + i)]), doutp[hook(1, tid * (vectorWidthMovie + vectorWidthUser) + i)]);
    }
    for (int i = 0; i < vectorWidthUser; i++) {
      atomic_add(&(dparams[hook(0, numMovies * vectorWidthMovie + u * vectorWidthUser + i)]), doutp[hook(1, tid * (vectorWidthMovie + vectorWidthUser) + vectorWidthMovie + i)]);
    }
  }
}