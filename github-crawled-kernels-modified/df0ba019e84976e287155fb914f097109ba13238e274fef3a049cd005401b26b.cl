//{"averageLuminance":2,"c":4,"delta":5,"gamma":3,"height":8,"input":0,"numChannels":7,"output":1,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float luminance(float r, float g, float b) {
  return (0.2126f * r) + (0.7152f * g) + (0.0722f * b);
}

kernel void toneMappingPattanaik(global float4* input, global float4* output, float averageLuminance, float gamma, float c, float delta, unsigned int width, unsigned int numChannels, unsigned int height) {
  unsigned int globalIdX = get_global_id(0);
  unsigned int globalIdY = get_global_id(1);
  float r, r1;
  float g, g1;
  float b, b1;
  float yLuminance = 0.0f;
  float cLPattanaik = 0.0f;
  float yLPattanaik = 0.0f;
  r1 = input[hook(0, width * globalIdY + globalIdX)].x;
  g1 = input[hook(0, width * globalIdY + globalIdX)].y;
  b1 = input[hook(0, width * globalIdY + globalIdX)].z;

  yLuminance = luminance(r1, g1, b1);

  float gcPattanaik = c * averageLuminance;

  if (globalIdX != 0 && globalIdY != 0 && globalIdX != width - 1 && globalIdY != height - 1) {
    float leftUp = 0.0f;
    float up = 0.0f;
    float rightUp = 0.0f;
    float left = 0.0f;
    float right = 0.0f;
    float leftDown = 0.0f;
    float down = 0.0f;
    float rightDown = 0.0f;

    r = input[hook(0, width * (globalIdY - 1) + globalIdX - 1)].x;
    g = input[hook(0, width * (globalIdY - 1) + globalIdX - 1)].y;
    b = input[hook(0, width * (globalIdY - 1) + globalIdX - 1)].z;

    leftUp = luminance(r, g, b);

    r = input[hook(0, width * (globalIdY - 1) + globalIdX)].x;
    g = input[hook(0, width * (globalIdY - 1) + globalIdX)].y;
    b = input[hook(0, width * (globalIdY - 1) + globalIdX)].z;

    up = luminance(r, g, b);

    r = input[hook(0, width * (globalIdY - 1) + globalIdX + 1)].x;
    g = input[hook(0, width * (globalIdY - 1) + globalIdX + 1)].y;
    b = input[hook(0, width * (globalIdY - 1) + globalIdX + 1)].z;

    rightUp = luminance(r, g, b);

    r = input[hook(0, width * globalIdY + globalIdX - 1)].x;
    g = input[hook(0, width * globalIdY + globalIdX - 1)].y;
    b = input[hook(0, width * globalIdY + globalIdX - 1)].z;

    left = luminance(r, g, b);

    r = input[hook(0, width * globalIdY + globalIdX + 1)].x;
    g = input[hook(0, width * globalIdY + globalIdX + 1)].y;
    b = input[hook(0, width * globalIdY + globalIdX + 1)].z;

    right = luminance(r, g, b);

    r = input[hook(0, width * (globalIdY + 1) + globalIdX - 1)].x;
    g = input[hook(0, width * (globalIdY + 1) + globalIdX - 1)].y;
    b = input[hook(0, width * (globalIdY + 1) + globalIdX - 1)].z;

    leftDown = luminance(r, g, b);

    r = input[hook(0, width * (globalIdY + 1) + globalIdX)].x;
    g = input[hook(0, width * (globalIdY + 1) + globalIdX)].y;
    b = input[hook(0, width * (globalIdY + 1) + globalIdX)].z;

    down = luminance(r, g, b);

    r = input[hook(0, width * (globalIdY + 1) + globalIdX + 1)].x;
    g = input[hook(0, width * (globalIdY + 1) + globalIdX + 1)].y;
    b = input[hook(0, width * (globalIdY + 1) + globalIdX + 1)].z;

    rightDown = luminance(r, g, b);

    yLPattanaik = (leftUp + up + rightUp + left + right + leftDown + down + rightDown) / 8;
  } else {
    yLPattanaik = yLuminance;
  }

  cLPattanaik = yLPattanaik * log(delta + yLPattanaik / yLuminance) + gcPattanaik;

  float yDPattanaik = yLuminance / (yLuminance + cLPattanaik);

  r = pow((r1 / yLuminance), gamma) * yDPattanaik;
  g = pow((g1 / yLuminance), gamma) * yDPattanaik;
  b = pow((b1 / yLuminance), gamma) * yDPattanaik;

  output[hook(1, width * globalIdY + globalIdX)].x = r;
  output[hook(1, width * globalIdY + globalIdX)].y = g;
  output[hook(1, width * globalIdY + globalIdX)].z = b;
  output[hook(1, width * globalIdY + globalIdX)].w = input[hook(0, width * globalIdY + globalIdX)].w;
}