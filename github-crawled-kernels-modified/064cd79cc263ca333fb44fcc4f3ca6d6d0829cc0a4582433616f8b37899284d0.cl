//{"from":2,"height":1,"to":3,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tick(int width, int height, global unsigned char* from, global unsigned char* to) {
  int gid = get_global_id(0);
  if (gid <= width * height) {
    int x = gid % width;
    int y = gid / width;

    int x0 = (x == 0 ? width - 1 : x - 1) * 4 + 3;
    int x1 = x * 4 + 3;
    int x2 = ((x + 1) == width ? 0 : x + 1) * 4 + 3;

    int y0 = (y == 0 ? height - 1 : y - 1) * width * 4;
    int y1 = y * width * 4;
    int y2 = ((y + 1) == height ? 0 : y + 1) * width * 4;

    int neighbours = from[hook(2, y0 + x0)] / 255 + from[hook(2, y0 + x1)] / 255 + from[hook(2, y0 + x2)] / 255 + from[hook(2, y1 + x0)] / 255 + from[hook(2, y1 + x2)] / 255 + from[hook(2, y2 + x0)] / 255 + from[hook(2, y2 + x1)] / 255 + from[hook(2, y2 + x2)] / 255;

    int prevR = from[hook(2, y1 + x1 - 3)];
    int prevA = from[hook(2, y1 + x1)];
    bool alive = (neighbours == 3 || (neighbours == 2 && prevA == 255));

    to[hook(3, y1 + x1 - 3)] = alive ? (prevA == 255 ? 10 + prevR * 0.90f : 255) : prevA * 0.90f;
    to[hook(3, y1 + x1 - 2)] = alive ? (prevA == 255 ? 10 + prevR * 0.90f : 255) : prevA * 0.45f;
    to[hook(3, y1 + x1 - 1)] = alive ? (prevA == 255 ? 10 + prevR * 0.90f : 255) : prevA * 0.45f;
    to[hook(3, y1 + x1)] = alive ? 255 : prevA * 0.75f;
  }
}