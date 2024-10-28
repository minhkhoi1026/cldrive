//{"buffer":3,"inputBuffer":0,"outputBuffer":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void parsum(global int* inputBuffer, global int* outputBuffer, int size) {
  size_t globalId = get_global_id(0);
  size_t localId = get_local_id(0);

  local int buffer[256];

  buffer[hook(3, localId)] = inputBuffer[hook(0, globalId)];
  barrier(0x01);

  for (int offset = get_local_size(0) >> 1; offset > 0; offset >>= 1) {
    if (localId < offset && globalId + offset < size)
      buffer[hook(3, localId)] += buffer[hook(3, localId + offset)];

    barrier(0x01);
  }

  if (localId == 0)
    outputBuffer[hook(1, get_group_id(0))] = buffer[hook(3, 0)];
}