//{"buffer":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FillBufferFloat(global float* buffer, const float value) {
  const int index = get_global_id(0);
  if (index < get_global_size(0)) {
    buffer[hook(0, index)] = value;
  }
}