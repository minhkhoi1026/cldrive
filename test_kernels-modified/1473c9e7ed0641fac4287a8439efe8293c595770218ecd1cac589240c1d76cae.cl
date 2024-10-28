//{"aux":3,"ext_out":0,"in":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void parallel_merge_local(global char* ext_out, global const float* in, global float* out, local float* aux) {
  int i = get_local_id(0);
  int wg = get_local_size(0);

  int offset = get_group_id(0) * wg;
  in += offset;
  out += offset;

  aux[hook(3, i)] = in[hook(1, i)];
  barrier(0x01);

  for (int length = 1; length < wg; length <<= 1) {
    float iData = aux[hook(3, i)];
    int ii = i & (length - 1);
    int sibling = (i - ii) ^ length;
    int pos = 0;
    for (int inc = length; inc > 0; inc >>= 1) {
      int j = sibling + pos + inc - 1;
      float jData = aux[hook(3, j)];
      bool smaller = (jData < iData) || (jData == iData && j < i);
      pos += (smaller) ? inc : 0;
      pos = min(pos, length);
    }
    int bits = 2 * length - 1;
    int dest = ((ii + pos) & bits) | (i & ~bits);
    barrier(0x01);
    aux[hook(3, dest)] = iData;
    barrier(0x01);
  }

  out[hook(2, i)] = aux[hook(3, i)];
  ext_out[hook(0, offset + i)] = out[hook(2, i)];
}