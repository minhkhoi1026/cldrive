//{"height":4,"image":2,"map":5,"map_in":0,"map_out":1,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
char get(global unsigned char* map, int x, int y, int w, int h, int gw, int gh) {
  if (x < 0 || y < 0 || x >= w || y >= h)
    return 0;
  else
    return map[hook(5, y * gw + x)];
}

kernel void devGolGenerate(global unsigned char* map_in, global unsigned char* map_out, write_only image2d_t image, int width, int height) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  int cell_count = 0;
  int gw = get_global_size(0);
  int gh = get_global_size(1);

  if (get(map_in, x - 1, y - 1, width, height, gw, gh))
    ++cell_count;
  if (get(map_in, x - 1, y, width, height, gw, gh))
    ++cell_count;
  if (get(map_in, x - 1, y + 1, width, height, gw, gh))
    ++cell_count;
  if (get(map_in, x, y - 1, width, height, gw, gh))
    ++cell_count;
  if (get(map_in, x, y + 1, width, height, gw, gh))
    ++cell_count;
  if (get(map_in, x + 1, y - 1, width, height, gw, gh))
    ++cell_count;
  if (get(map_in, x + 1, y, width, height, gw, gh))
    ++cell_count;
  if (get(map_in, x + 1, y + 1, width, height, gw, gh))
    ++cell_count;

  if (get(map_in, x, y, width, height, gw, gh) == 1 && (cell_count > 3 || cell_count < 2))
    map_out[hook(1, y * gw + x)] = 0;
  else if (get(map_in, x, y, width, height, gw, gh) == 0 && cell_count == 3)
    map_out[hook(1, y * gw + x)] = 1;
  else
    map_out[hook(1, y * gw + x)] = get(map_in, x, y, width, height, gw, gh);

  write_imagef(image, (int2)(x, y), map_out[hook(1, y * gw + x)] ? (1.0) : (0.0));
}