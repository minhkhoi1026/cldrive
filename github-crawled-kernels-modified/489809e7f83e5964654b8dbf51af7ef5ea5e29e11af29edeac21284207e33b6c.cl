//{"dst":0,"numElems":3,"shift":4,"srcBorder":1,"srcData":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_red_extrapolate(global int* dst, global const int* srcBorder, global const int* srcData, int numElems, const int shift) {
  int index = get_local_size(0) * get_local_id(0);

  if (index < numElems - 1) {
    int sum = srcBorder[hook(1, index)];

    for (int i = 0; i < get_local_size(0) && index + i < numElems; ++i) {
      sum += srcData[hook(2, index + i)];
      dst[hook(0, index + i + shift)] = sum;
    }
  }
}