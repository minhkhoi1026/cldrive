//{"dDest":0,"elementHeights":1,"elementPositions":2,"horizontalExtent":9,"inputL":5,"inputS":6,"outputL":7,"outputS":8,"probeRadius":4,"sin_deg":3,"verticalExtent":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ckUsedLines_g(global unsigned short* dDest, global float* elementHeights, global float* elementPositions, float sin_deg, float probeRadius, unsigned int inputL, unsigned int inputS, unsigned int outputL, unsigned int outputS, float horizontalExtent, float verticalExtent) {
  unsigned int globalPosX = get_global_id(0);
  unsigned int globalPosY = get_global_id(1);

  float x_sensor_pos = 0;
  float y_sensor_pos = 0;
  float center_to_sensor_a = 0;
  float center_to_sensor_b = 0;
  float center_to_sensor_c = 0;
  float distance_to_sensor_direction = 0;
  float distance_sensor_target = 0;

  if (globalPosX < outputL && globalPosY < outputS) {
    float x_cm = (float)globalPosX / outputL * horizontalExtent;
    float y_cm = (float)globalPosY / (float)outputS * verticalExtent;

    int maxLine = inputL;
    int minLine = 0;

    float x_center_pos = horizontalExtent / 2.0;
    float y_center_pos = probeRadius;

    for (int l_s = minLine; l_s <= inputL; l_s += 1) {
      x_sensor_pos = elementPositions[hook(2, l_s)];
      y_sensor_pos = elementHeights[hook(1, l_s)];

      distance_sensor_target = sqrt((x_cm - x_sensor_pos) * (x_cm - x_sensor_pos) + (y_cm - y_sensor_pos) * (y_cm - y_sensor_pos));

      center_to_sensor_a = y_sensor_pos - y_center_pos;
      center_to_sensor_b = x_center_pos - x_sensor_pos;
      center_to_sensor_c = -(center_to_sensor_a * x_center_pos + center_to_sensor_b * y_center_pos);
      distance_to_sensor_direction = fabs((center_to_sensor_a * x_cm + center_to_sensor_b * y_cm + center_to_sensor_c)) / (sqrt(center_to_sensor_a * center_to_sensor_a + center_to_sensor_b * center_to_sensor_b));

      if (distance_to_sensor_direction < (sin_deg * distance_sensor_target)) {
        minLine = l_s;
        break;
      }
    }

    for (int l_s = maxLine - 1; l_s > minLine; l_s -= 1) {
      x_sensor_pos = elementPositions[hook(2, l_s)];
      y_sensor_pos = elementHeights[hook(1, l_s)];

      distance_sensor_target = sqrt((x_cm - x_sensor_pos) * (x_cm - x_sensor_pos) + (y_cm - y_sensor_pos) * (y_cm - y_sensor_pos));

      center_to_sensor_a = y_sensor_pos - y_center_pos;
      center_to_sensor_b = x_center_pos - x_sensor_pos;
      center_to_sensor_c = -(center_to_sensor_a * x_center_pos + center_to_sensor_b * y_center_pos);
      distance_to_sensor_direction = fabs((center_to_sensor_a * x_cm + center_to_sensor_b * y_cm + center_to_sensor_c)) / (sqrt(center_to_sensor_a * center_to_sensor_a + center_to_sensor_b * center_to_sensor_b));

      if (distance_to_sensor_direction < sin_deg * distance_sensor_target) {
        maxLine = l_s;
        break;
      }
    }

    dDest[hook(0, globalPosY * 3 * outputL + 3 * globalPosX)] = (maxLine - minLine);
    dDest[hook(0, globalPosY * 3 * outputL + 3 * globalPosX + 1)] = minLine;
    dDest[hook(0, globalPosY * 3 * outputL + 3 * globalPosX + 2)] = maxLine;
  }
}