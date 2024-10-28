//{"out":2,"vin":1,"vsize":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_diagvec_right(unsigned int vsize, global const float* vin, global float* out) {
  const unsigned int gid = get_global_id(0);

  for (unsigned int i = 0; i < vsize; i++)
    out[hook(2, gid * vsize + i)] = (i == gid) ? vin[hook(1, gid)] : 0.0f;
}