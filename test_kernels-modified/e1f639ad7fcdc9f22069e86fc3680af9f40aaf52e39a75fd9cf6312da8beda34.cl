//{"batchSize":7,"inp":1,"numMovies":4,"numUsers":3,"outp":0,"params":2,"vectorWidthMovie":5,"vectorWidthUser":6}
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

kernel void movieuser_forward(global float* outp, global int* inp, global float* params, int numUsers, int numMovies, int vectorWidthMovie, int vectorWidthUser, int batchSize) {
  int tid = get_global_id(0);

  if (tid < batchSize) {
    int m = inp[hook(1, 2 * tid)];
    int u = inp[hook(1, 2 * tid + 1)];

    for (int i = 0; i < vectorWidthMovie; i++) {
      outp[hook(0, tid * (vectorWidthMovie + vectorWidthUser) + i)] = params[hook(2, m * vectorWidthMovie + i)];
    }
    for (int i = 0; i < vectorWidthUser; i++) {
      outp[hook(0, tid * (vectorWidthMovie + vectorWidthUser) + vectorWidthMovie + i)] = params[hook(2, numMovies * vectorWidthMovie + u * vectorWidthUser + i)];
    }
  }
}