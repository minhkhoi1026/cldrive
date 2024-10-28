//{"bottom_data":4,"channels":2,"eps":6,"has_scale":8,"n":1,"p":7,"scale":3,"shared":9,"size_in_channel":0,"top_data":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void AtomicAdd(volatile global float* source, const float operand) {
  union {
    unsigned int intVal;
    float floatVal;
  } newVal;
  union {
    unsigned int intVal;
    float floatVal;
  } prevVal;

  prevVal.floatVal = *source;

  while (true) {
    newVal.floatVal = prevVal.floatVal + operand;
    newVal.intVal = atomic_cmpxchg((volatile global unsigned int*)source, prevVal.intVal, newVal.intVal);

    if (newVal.intVal == prevVal.intVal) {
      break;
    }

    prevVal.intVal = newVal.intVal;
  }
}

;

kernel void NormalizeNoAcrossSpatial(int size_in_channel, int n, int channels, global const float* restrict scale, global const float* restrict bottom_data, global float* restrict top_data, float eps, int p, int has_scale, int shared) {
  int index = get_global_id(0);
  const int global_size = get_global_size(0);

  for (; index < size_in_channel * n; index += global_size) {
    float sqr_sum = 0.f;
    int num_index = index / size_in_channel;
    int index_in_channel = index % size_in_channel;
    int data_index = num_index * channels * size_in_channel + index_in_channel;

    for (int i = 0; i < channels; ++i) {
      if (p == 1) {
        sqr_sum += fabs(bottom_data[hook(4, data_index + i * size_in_channel)]);
      } else {
        sqr_sum += bottom_data[hook(4, data_index + i * size_in_channel)] * bottom_data[hook(4, data_index + i * size_in_channel)];
      }
    }

    float norm;

    if (p == 1) {
      norm = 1.f / (sqr_sum + eps);
    } else {
      norm = 1.f / (sqrt(sqr_sum) + eps);
    }

    for (int i = 0; i < channels; ++i) {
      if (has_scale) {
        if (shared) {
          top_data[hook(5, data_index + i * size_in_channel)] = bottom_data[hook(4, data_index + i * size_in_channel)] * scale[hook(3, 0)] * norm;
        } else {
          top_data[hook(5, data_index + i * size_in_channel)] = bottom_data[hook(4, data_index + i * size_in_channel)] * scale[hook(3, i)] * norm;
        }
      } else {
        top_data[hook(5, data_index + i * size_in_channel)] = bottom_data[hook(4, data_index + i * size_in_channel)] * norm;
      }
    }
  }
}