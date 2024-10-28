//{"amount":4,"globalBuffer":0,"globalSize":1,"localValue":2,"type":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mathTransform(global float* globalBuffer, int globalSize, local float* localValue, int type, int amount) {
  int i = get_global_id(0);

  if (i >= globalSize) {
    return;
  }

  *localValue = globalBuffer[hook(0, i)];
  switch (type) {
    case 0:
      *localValue += amount;
      break;
    case 1:
      *localValue -= amount;
      break;
    case 2:
      *localValue *= amount;
      break;
    case 3:
      *localValue /= amount;
      break;
  }
  globalBuffer[hook(0, i)] = *localValue;
}