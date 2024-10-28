//{"anchors":8,"biasData":2,"cell_size":3,"classes":4,"classfix":5,"cols":7,"count":0,"dst":10,"input":11,"output":12,"rows":6,"src":1,"thresh":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void softmax_activ(const int count, global const float* src, global const float* biasData, const int cell_size, const int classes, const int classfix, const int rows, const int cols, const int anchors, const float thresh, global float* dst) {
  for (int index = get_global_id(0); index < count; index += get_global_size(0)) {
    int box_index = index * cell_size;
    float largest = -0x1.fffffep127f;
    global const float* input = src + box_index + 5;
    global float* output = dst + box_index + 5;

    for (int i = 0; i < classes; ++i)
      largest = fmax(largest, input[hook(11, i)]);

    float sum = 0;
    for (int i = 0; i < classes; ++i) {
      float e = exp((input[hook(11, i)] - largest));
      sum += e;
      output[hook(12, i)] = e;
    }

    int y = index / anchors / cols;
    int x = index / anchors % cols;
    int a = index - anchors * (x + y * cols);
    float scale = dst[hook(10, box_index + 4)];
    if (classfix == -1 && scale < .5)
      scale = 0;

    float v1 = src[hook(1, box_index + 0)];
    float v2 = src[hook(1, box_index + 1)];
    float l1 = 1.f / (1.f + exp(-v1));
    float l2 = 1.f / (1.f + exp(-v2));

    dst[hook(10, box_index + 0)] = (x + l1) / cols;
    dst[hook(10, box_index + 1)] = (y + l2) / rows;
    dst[hook(10, box_index + 2)] = exp(src[hook(1, box_index + 2)]) * biasData[hook(2, 2 * a)] / cols;
    dst[hook(10, box_index + 3)] = exp(src[hook(1, box_index + 3)]) * biasData[hook(2, 2 * a + 1)] / rows;

    for (int i = 0; i < classes; ++i) {
      float prob = scale * output[hook(12, i)] / sum;
      output[hook(12, i)] = (prob > thresh) ? prob : 0;
    }
  }
}