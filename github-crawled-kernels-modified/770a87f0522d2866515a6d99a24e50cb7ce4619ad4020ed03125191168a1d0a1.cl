//{"_aspectRatios":8,"_layerHeight":12,"_layerWidth":13,"_maxSize":4,"_minSize":3,"_offsetsX":5,"_offsetsY":6,"aspectRatios_size":9,"dst":11,"imgHeight":14,"imgWidth":15,"nthreads":0,"offsetsX_size":7,"scales":10,"stepX":1,"stepY":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prior_box(const int nthreads, const float stepX, const float stepY, const float _minSize, const float _maxSize, global const float* _offsetsX, global const float* _offsetsY, const int offsetsX_size, global const float* _aspectRatios, const int aspectRatios_size, global const float* scales, global float* dst, const int _layerHeight, const int _layerWidth, const int imgHeight, const int imgWidth) {
  for (int index = get_global_id(0); index < nthreads; index += get_global_size(0)) {
    int w = index % _layerWidth;
    int h = index / _layerWidth;
    global float* outputPtr;
    int aspect_count = (_maxSize > 0) ? 1 : 0;
    outputPtr = dst + index * 4 * offsetsX_size * (1 + aspect_count + aspectRatios_size);

    float _boxWidth, _boxHeight;
    float4 vec;
    _boxWidth = _boxHeight = _minSize * scales[hook(10, 0)];
    for (int i = 0; i < offsetsX_size; ++i) {
      float center_x = (w + _offsetsX[hook(5, i)]) * stepX;
      float center_y = (h + _offsetsY[hook(6, i)]) * stepY;

      vec.x = (center_x - _boxWidth * 0.5f) / imgWidth;
      vec.y = (center_y - _boxHeight * 0.5f) / imgHeight;
      vec.z = (center_x + _boxWidth * 0.5f) / imgWidth;
      vec.w = (center_y + _boxHeight * 0.5f) / imgHeight;
      vstore4(vec, 0, outputPtr);

      outputPtr += 4;
    }

    if (_maxSize > 0) {
      _boxWidth = _boxHeight = native_sqrt(_minSize * _maxSize) * scales[hook(10, 1)];

      for (int i = 0; i < offsetsX_size; ++i) {
        float center_x = (w + _offsetsX[hook(5, i)]) * stepX;
        float center_y = (h + _offsetsY[hook(6, i)]) * stepY;

        vec.x = (center_x - _boxWidth * 0.5f) / imgWidth;
        vec.y = (center_y - _boxHeight * 0.5f) / imgHeight;
        vec.z = (center_x + _boxWidth * 0.5f) / imgWidth;
        vec.w = (center_y + _boxHeight * 0.5f) / imgHeight;
        vstore4(vec, 0, outputPtr);

        outputPtr += 4;
      }
    }

    for (int r = 0; r < aspectRatios_size; ++r) {
      float ar = native_sqrt(_aspectRatios[hook(8, r)]);
      float scale = scales[hook(10, (_maxSize > 0 ? 2 : 1) + r)];

      _boxWidth = _minSize * ar * scale;
      _boxHeight = _minSize / ar * scale;

      for (int i = 0; i < offsetsX_size; ++i) {
        float center_x = (w + _offsetsX[hook(5, i)]) * stepX;
        float center_y = (h + _offsetsY[hook(6, i)]) * stepY;

        vec.x = (center_x - _boxWidth * 0.5f) / imgWidth;
        vec.y = (center_y - _boxHeight * 0.5f) / imgHeight;
        vec.z = (center_x + _boxWidth * 0.5f) / imgWidth;
        vec.w = (center_y + _boxHeight * 0.5f) / imgHeight;
        vstore4(vec, 0, outputPtr);

        outputPtr += 4;
      }
    }
  }
}