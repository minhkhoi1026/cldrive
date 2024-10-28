//{"cmdType":2,"deadSensor":4,"energy":3,"event":6,"event2":7,"links":0,"min":1,"size":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sampleKernel(global char* links, global const int* min, global const int* cmdType, global int* energy, global char* deadSensor, global int* size, global int* event, global int* event2) {
  int lmin = min[hook(1, 0)];
  int lsize = size[hook(5, 0)];

  int idx = get_global_id(0);

  int consumption = 0;
  for (int i = 0; i < lsize; i++)
    consumption = consumption + (links[hook(0, idx * lsize + i)] * cmdType[hook(2, i)] * (1 - deadSensor[hook(4, i)]));

  energy[hook(3, idx)] = energy[hook(3, idx)] - (consumption * lmin);

  if (energy[hook(3, idx)] <= 0) {
    energy[hook(3, idx)] = 0;
  }

  event[hook(6, idx)] = event[hook(6, idx)] - lmin;
  event2[hook(7, idx)] = event2[hook(7, idx)] - lmin;
}