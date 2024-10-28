//{"imageHeight":9,"imageMaxX":12,"imageMaxY":13,"imageMinX":10,"imageMinY":11,"imageWidth":8,"maximumIterations":14,"outputImage":15,"sampleMaxA":4,"sampleMaxB":5,"sampleMaxC":6,"sampleMaxD":7,"sampleMinA":0,"sampleMinB":1,"sampleMinC":2,"sampleMinD":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Buddhabrot(float sampleMinA, float sampleMinB, float sampleMinC, float sampleMinD, float sampleMaxA, float sampleMaxB, float sampleMaxC, float sampleMaxD, int imageWidth, int imageHeight, float imageMinX, float imageMinY, float imageMaxX, float imageMaxY, int maximumIterations, global int* outputImage) {
  const float sx = (get_global_id(0) + 0.5) / get_global_size(0);
  const float sy = (get_global_id(1) + 0.5) / get_global_size(1);
  const float a = sampleMinA + sx * (sampleMaxA - sampleMinA);
  const float b = sampleMinB + sy * (sampleMaxB - sampleMinB);
  const float c = sampleMinC + sx * (sampleMaxC - sampleMinC);
  const float d = sampleMinD + sy * (sampleMaxD - sampleMinD);

  bool escaped = false;
  {
    float zR = a;
    float zI = b;
    for (int i = 0; i < maximumIterations; i++) {
      if (zR * zR + zI * zI >= 4.0) {
        escaped = true;
        break;
      }
      float tzR = zR * zR - zI * zI + c;
      float tzI = zR * zI + zR * zI + d;
      zR = tzR;
      zI = tzI;
    }
  }

  if (escaped) {
    float zR = a;
    float zI = b;
    for (int i = 0; i < maximumIterations; i++) {
      if (zR * zR + zI * zI >= 4.0) {
        break;
      }
      float tzR = zR * zR - zI * zI + c;
      float tzI = zR * zI + zR * zI + d;
      zR = tzR;
      zI = tzI;

      int x = floor(((zR - imageMinX) * imageWidth) / (imageMaxX - imageMinX));
      int y = floor(((zI - imageMinY) * imageHeight) / (imageMaxY - imageMinY));
      if (x >= 0 && x < imageWidth && y >= 0 && y < imageHeight) {
        global int* address = outputImage + y * imageWidth + x;

        atom_inc(address);
      }
    }
  }
}