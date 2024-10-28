//{"Gx":5,"Gx[i]":4,"Gy":3,"Gy[i]":2,"frame_in":0,"frame_out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sobel(global unsigned int* restrict frame_in, global unsigned int* restrict frame_out) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_global_size(0);
  int height = get_global_size(1);
  int index = x + y * width;
  long int size = width * height;

  int Gx[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
  int Gy[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
  int G_x = 0, G_y = 0, G = 0;
  int i = 0, j = 0;
  if (index < size && (x > 1 && y > 1) && (x < (width - 1) && y < (height - 1))) {
    for (i = 0; i < 3; i++) {
      for (j = 0; j < 3; j++) {
        G_y += (Gy[hook(3, i)][hook(2, j)]) * frame_in[hook(0, (x + j - 1) + (width * (y + i - 1)))];
        G_x += (Gx[hook(5, i)][hook(4, j)]) * frame_in[hook(0, (x + j - 1) + (width * (y + i - 1)))];
      }
    }

    G = abs(G_x) + abs(G_y);

    if (G > 255)
      frame_out[hook(1, index)] = 255;
    else
      frame_out[hook(1, index)] = G;
  }
}