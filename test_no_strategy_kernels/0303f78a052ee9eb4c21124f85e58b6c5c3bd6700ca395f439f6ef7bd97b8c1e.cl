//{"_convMatrix3x3":0,"_height":4,"_imageIn":1,"_imageOut":2,"_width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void processPixel(global float* _convMatrix3x3, global char* _imageIn, global char* _imageOut, int _width, int _height, int _x, int _y) {
  float accum = 0.0f;
  int count = 0;
  for (int dx = -3; dx < 6; dx += 3) {
    for (int dy = -1; dy < 2; dy++) {
      int rgb = 0xff & _imageIn[hook(1, (((_y + dy) * _width) + (_x + dx)))];
      accum = accum + ((float)rgb * _convMatrix3x3[hook(0, count++)]);
    }
  }
  char value = (char)max(0, min((int)accum, 255));
  _imageOut[hook(2, (_y * _width) + _x)] = value;
  return;
}

kernel void applyConvolution(global float* _convMatrix3x3, global char* _imageIn, global char* _imageOut, int _width, int _height) {
  int x = get_global_id(0) % (_width * 3);
  int y = get_global_id(0) / (_width * 3);
  if (x > 3 && x < ((_width * 3) - 3) && y > 1 && y < (_height - 1)) {
    processPixel(_convMatrix3x3, _imageIn, _imageOut, _width * 3, _height, x, y);
  }
}