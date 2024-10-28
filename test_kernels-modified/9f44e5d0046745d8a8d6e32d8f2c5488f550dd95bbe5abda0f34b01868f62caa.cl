//{"distance":3,"prnew":2,"prold":1,"rowtotal":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void caldistance(int rowtotal, global float* prold, global float* prnew, global float* distance) {
  distance[hook(3, 0)] = 0;
  for (int i = 0; i < rowtotal; i++) {
    (distance[hook(3, 0)]) += (prnew[hook(2, i)] - prold[hook(1, i)]) * (prnew[hook(2, i)] - prold[hook(1, i)]);
  }
}