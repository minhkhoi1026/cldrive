//{"errVec":0,"incErr":2,"sizeErr":3,"specificError":4,"startErr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_specific_error(global float* errVec, unsigned int startErr, unsigned int incErr, unsigned int sizeErr, global float* specificError) {
  for (unsigned int i = get_global_id(0); i < sizeErr; i += get_global_size(0))
    errVec[hook(0, i * incErr + startErr)] = pow(errVec[hook(0, i * incErr + startErr)], 2);

  barrier(0x02);

  *specificError = 0;
  for (unsigned int i = 0; i < sizeErr; i++)
    *specificError += errVec[hook(0, i * incErr + startErr)];
  *specificError /= 2;
}