//{"coords":1,"height":3,"labels":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_coordinates(global int* labels, global unsigned int* coords, int width, int height) {
  int2 pos = (int2)(get_global_id(0) + 1, get_global_id(1) + 1);
  int2 pos_img = (int2)(pos.x - 1, pos.y - 1);
  if (pos.x > width || pos.y > height)
    return;

  int adr = pos.x + pos.y * (width + 2);
  int box_num = -1 * labels[hook(0, adr)];
  if (0 < box_num) {
    int box_adr = (box_num - 1) * 2;
    atom_add(coords + box_adr++, pos_img.x);
    atom_add(coords + box_adr, pos_img.y);
  }
}