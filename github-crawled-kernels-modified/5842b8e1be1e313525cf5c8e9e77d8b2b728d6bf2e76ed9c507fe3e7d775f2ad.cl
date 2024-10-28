//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void address2D(global float4* data) {
  int localIDX = get_local_id(0);
  int localIDY = get_local_id(1);
  int globalIDX = get_global_id(0);
  int globalIDY = get_global_id(1);

  data[hook(0, globalIDX + get_global_size(0) * globalIDY)] = (float4)(globalIDX, globalIDY, localIDX, localIDY);
}