//{"c":2,"f":10,"i":6,"l":8,"output":0,"s":4,"temp":1,"uc":3,"ui":7,"ul":9,"us":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel1(global float* output, local float* temp, char c, uchar uc, short s, ushort us, int i, unsigned int ui, long l, ulong ul, float f) {
  if (i > 5)
    temp[hook(1, 0)] = (float)c + (float)uc + (float)s + (float)us;
  else
    temp[hook(1, 0)] = (float)ui + (float)l + (float)ul;
  output[hook(0, 0)] = temp[hook(1, 0)] + f;
}