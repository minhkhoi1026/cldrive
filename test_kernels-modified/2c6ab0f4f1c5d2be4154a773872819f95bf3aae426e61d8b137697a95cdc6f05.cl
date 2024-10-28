//{"currentBucket":3,"depth":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void infiniteFocus(global uchar* input, global uchar* output, global uchar* depth, unsigned int currentBucket) {
  int gid = get_global_id(0);

  if (depth[hook(2, gid)] == (currentBucket + 1)) {
    output[hook(1, gid)] = input[hook(0, gid)];
  }
}