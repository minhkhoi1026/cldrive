//{"heights":3,"keep":5,"n":7,"order":4,"threshold":6,"widths":2,"xmins":0,"ymins":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float lowerleft_iou(float* xmins, float* ymins, float* widths, float* heights, int i, int j) {
  float x0 = (((xmins[hook(0, i)]) > (xmins[hook(0, j)])) ? (xmins[hook(0, i)]) : (xmins[hook(0, j)]));
  float y0 = (((ymins[hook(1, i)]) > (ymins[hook(1, j)])) ? (ymins[hook(1, i)]) : (ymins[hook(1, j)]));
  float x1 = (((xmins[hook(0, i)] + widths[hook(2, i)]) < (xmins[hook(0, j)] + widths[hook(2, j)])) ? (xmins[hook(0, i)] + widths[hook(2, i)]) : (xmins[hook(0, j)] + widths[hook(2, j)]));
  float y1 = (((ymins[hook(1, i)] + heights[hook(3, i)]) < (ymins[hook(1, j)] + heights[hook(3, j)])) ? (ymins[hook(1, i)] + heights[hook(3, i)]) : (ymins[hook(1, j)] + heights[hook(3, j)]));

  float box1Area = widths[hook(2, i)] * heights[hook(3, i)];
  float box2Area = widths[hook(2, j)] * heights[hook(3, j)];

  float union_area = 0;
  if (x1 > x0) {
    union_area = (x1 - x0) * (y1 - y0);
  }

  union_area = (((union_area) > (0)) ? (union_area) : (0));
  float tot_area = box1Area + box2Area - union_area;
  float retval = 0;

  if (tot_area > 0.0) {
    retval = (((1.0) < (union_area / tot_area)) ? (1.0) : (union_area / tot_area));
  }
  return retval;
}

kernel void nms(global float* xmins, global float* ymins, global float* widths, global float* heights, global int* order, global int* keep, float threshold, int n) {
  size_t idx = get_global_id(0);

  int i = (idx / n);
  int j = i + (idx % n) + 1;
  if (j < n) {
    float iou_result = 0;
    float x0 = (((xmins[hook(0, i)]) > (xmins[hook(0, j)])) ? (xmins[hook(0, i)]) : (xmins[hook(0, j)]));
    float y0 = (((ymins[hook(1, i)]) > (ymins[hook(1, j)])) ? (ymins[hook(1, i)]) : (ymins[hook(1, j)]));
    float x1 = (((xmins[hook(0, i)] + widths[hook(2, i)]) < (xmins[hook(0, j)] + widths[hook(2, j)])) ? (xmins[hook(0, i)] + widths[hook(2, i)]) : (xmins[hook(0, j)] + widths[hook(2, j)]));
    float y1 = (((ymins[hook(1, i)] + heights[hook(3, i)]) < (ymins[hook(1, j)] + heights[hook(3, j)])) ? (ymins[hook(1, i)] + heights[hook(3, i)]) : (ymins[hook(1, j)] + heights[hook(3, j)]));

    float box1Area = widths[hook(2, i)] * heights[hook(3, i)];
    float box2Area = widths[hook(2, j)] * heights[hook(3, j)];

    float union_area = 0;
    if (x1 > x0) {
      union_area = (x1 - x0) * (y1 - y0);
    }

    union_area = (((union_area) > (0)) ? (union_area) : (0));
    float tot_area = box1Area + box2Area - union_area;
    float retval = 0;

    if (tot_area > 0.0) {
      iou_result = (((1.0) < (union_area / tot_area)) ? (1.0) : (union_area / tot_area));
    }
    if (iou_result > threshold) {
      keep[hook(5, j)] = 0;
    }
  }
}