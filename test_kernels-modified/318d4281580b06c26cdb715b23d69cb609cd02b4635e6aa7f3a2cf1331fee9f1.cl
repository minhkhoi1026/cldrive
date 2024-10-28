//{"Buffer":0,"Value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SetValue(global float* Buffer, float Value) {
  unsigned int id = get_global_id(0);
  Buffer[hook(0, id)] = Value;
}