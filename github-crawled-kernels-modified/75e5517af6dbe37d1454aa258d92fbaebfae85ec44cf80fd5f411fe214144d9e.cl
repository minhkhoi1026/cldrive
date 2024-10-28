//{"out":0,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global float* out, float x, float y) {
  int first_result;

  if (y >= 1.25f) {
    if (x > 0) {
      first_result = 0;
    } else {
      first_result = 1;
    }
  } else if (y >= 1.5f) {
    if (x > 0) {
      first_result = 2;
    } else {
      first_result = 3;
    }
  } else {
    if (y + 1.0f > 0) {
      first_result = 4;
    } else {
      first_result = 5;
    }
  }

  float fr = (float)(first_result);

  float result = -1.0f;
  if (fr == 0)
    result = 1.0f;
  else if (fr == 1)
    result = 0.0f;
  else if (fr == 2)
    result = 2.0f;

  *out = result;
}