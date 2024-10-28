//{"deltaWeightsMomentum":13,"gradient":8,"gradientMomentum":12,"gradient_internal_size2":9,"learningRate":15,"minSquaredGradient":16,"prevDeltaWeights":2,"prevDeltaWeights_internal_size2":3,"prevGradient":4,"prevGradient_internal_size2":5,"prevSquaredGradient":0,"prevSquaredGradient_internal_size2":1,"size1":10,"size2":11,"squaredGradientMomentum":14,"weights":6,"weights_internal_size2":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rms_prop_learning_rate(global float* prevSquaredGradient, unsigned int prevSquaredGradient_internal_size2, global float* prevDeltaWeights, unsigned int prevDeltaWeights_internal_size2, global float* prevGradient, unsigned int prevGradient_internal_size2, global float* weights, unsigned int weights_internal_size2, global float* gradient, unsigned int gradient_internal_size2, unsigned int size1, unsigned int size2, float gradientMomentum, float deltaWeightsMomentum, float squaredGradientMomentum, float learningRate, float minSquaredGradient) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  for (unsigned int row = row_gid; row < size1; row += get_num_groups(0)) {
    for (unsigned int col = col_gid; col < size2; col += get_local_size(0)) {
      prevGradient[hook(4, row * prevGradient_internal_size2 + col)] = gradientMomentum * prevGradient[hook(4, row * prevGradient_internal_size2 + col)] + (1 - gradientMomentum) * gradient[hook(8, row * gradient_internal_size2 + col)];
      prevSquaredGradient[hook(0, row * prevSquaredGradient_internal_size2 + col)] = squaredGradientMomentum * prevSquaredGradient[hook(0, row * prevSquaredGradient_internal_size2 + col)] + (1 - squaredGradientMomentum) * gradient[hook(8, row * gradient_internal_size2 + col)] * gradient[hook(8, row * gradient_internal_size2 + col)];
      prevDeltaWeights[hook(2, row * prevDeltaWeights_internal_size2 + col)] = deltaWeightsMomentum * prevDeltaWeights[hook(2, row * prevDeltaWeights_internal_size2 + col)] - learningRate * gradient[hook(8, row * gradient_internal_size2 + col)] / sqrt(prevSquaredGradient[hook(0, row * prevSquaredGradient_internal_size2 + col)] - prevGradient[hook(4, row * prevGradient_internal_size2 + col)] * prevGradient[hook(4, row * prevGradient_internal_size2 + col)] + minSquaredGradient);
      weights[hook(6, row * weights_internal_size2 + col)] += prevDeltaWeights[hook(2, row * prevDeltaWeights_internal_size2 + col)];
    }
  }
}