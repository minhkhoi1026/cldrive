//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void unaligned(global int* in, global int* out) {
  global char* char_ptr = (global char*)in + 2;
  global int* address = (global int*)char_ptr;
  *out = *address;
}