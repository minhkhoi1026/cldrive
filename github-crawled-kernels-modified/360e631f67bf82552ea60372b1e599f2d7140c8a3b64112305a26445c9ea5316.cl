//{"dest":0,"length":3,"offset":2,"presumWindows":4,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void circsum(global float* dest, global float* src, int offset, int length, int presumWindows) {
  float sum = 0;

  offset += get_global_id(0);

  while (presumWindows-- != 0) {
    offset = (offset + length - get_global_size(0)) % length;
    sum += src[hook(1, offset)] * (presumWindows + 1) * (presumWindows + 1);
  }

  dest[hook(0, get_global_id(0))] = sum;
}