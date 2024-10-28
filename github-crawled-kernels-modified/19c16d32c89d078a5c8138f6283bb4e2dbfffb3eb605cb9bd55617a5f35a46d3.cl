//{"v":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void user_event(global float4* v) {
  *v *= -1.0f;
}