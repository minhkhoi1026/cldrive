//{"R":0,"S":1,"T":2,"x":3,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bar(global float* R, global float* S, global float* T, float x, float y) {
  *R = x * y;
  *S = x / y;
  *T = x;
}