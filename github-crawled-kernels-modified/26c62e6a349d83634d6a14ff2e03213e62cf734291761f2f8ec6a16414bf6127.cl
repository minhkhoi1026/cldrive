//{"Buffer":4,"height":3,"in":0,"out":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Stencil3(global float* in, global float* out, int width, int height, local float* Buffer) {
  int2 globalID = (int2)(get_global_id(0), get_global_id(1));
  int2 localID = (int2)(get_local_id(0), get_local_id(1));
  int2 localSize = (int2)(get_local_size(0), get_local_size(1));
  int2 globalSize = (int2)(get_global_size(0), get_global_size(1));

  int2 group = (int2)(get_group_id(0), get_group_id(1));

  int dim = get_work_dim();

  int pos = (globalID.x + 1) + (globalID.y + 1) * width;
  int localPos = (localID.x + 1) + (localID.y + 1) * (localSize.x + 2);
  int loadIndex = localID.x + (localID.y * localSize.x);
  int globalStartPos = group.x * localSize.x + (group.y * localSize.y) * (globalSize.x + 2);
  int numcopys = (localSize.x + 2) * (localSize.y + 2);
  int globalLoadIndex = 0;
  while (loadIndex < numcopys) {
    globalLoadIndex = globalStartPos + loadIndex + (loadIndex / (localSize.x + 2)) * (globalSize.x - localSize.x);
    Buffer[hook(4, loadIndex)] = in[hook(0, globalLoadIndex)];
    loadIndex = loadIndex + (localSize.x * localSize.y);
  }

  barrier(0x01);

  out[hook(1, pos)] = (Buffer[hook(4, localPos - 1)] + Buffer[hook(4, localPos + 1)] + Buffer[hook(4, localPos - (localSize.x + 2))] + Buffer[hook(4, localPos + (localSize.x + 2))]) / 4;
}