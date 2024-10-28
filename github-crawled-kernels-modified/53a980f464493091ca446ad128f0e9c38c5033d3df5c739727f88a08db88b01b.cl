//{"frame_in":0,"frame_out":1,"hough_h":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hough(global unsigned int* restrict frame_in, global unsigned int* restrict frame_out, const unsigned int hough_h) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_global_size(0);
  int height = get_global_size(1);
  int index = x + y * width;
  long int size = width * height;
  double DEG2RAD = 0.0174533;
  double center_x = width / 2;
  double center_y = height / 2;

  if (frame_in[hook(0, index)] > 250) {
    for (int t = 0; t < 180; t++) {
      double r = (((double)x - center_x) * cos((double)t * DEG2RAD)) + (((double)y - center_y) * sin((double)t * DEG2RAD));
      frame_out[hook(1, (int)((round(r + hough_h) * 180.)) + t)]++;
    }
  }
}