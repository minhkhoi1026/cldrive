//{"a":0,"b":1,"mask":2,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void permutate(global float8* a, global float8* b, global uint16* mask, global float16* result) {
  unsigned int id = get_global_id(0);
  float8 in1 = a[hook(0, id)];
  float8 in2 = b[hook(1, id)];
  result[hook(3, id)] = shuffle2(in1, in2, *mask);
}