//{"height":2,"labels":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void update_blob_ids(global int* labels, int width, int height) {
  int2 pos = (int2)(get_global_id(0) + 1, get_global_id(1) + 1);
  if (pos.x > width || pos.y > height)
    return;

  int adr = pos.x + pos.y * (width + 2);
  int idx = labels[hook(0, adr)];
  int num = 1;

  if (idx > 0) {
    num = labels[hook(0, idx)];
  } else if (idx < 0) {
    num = idx;
  }

  if (num < 0) {
    labels[hook(0, adr)] = num;
  }
}