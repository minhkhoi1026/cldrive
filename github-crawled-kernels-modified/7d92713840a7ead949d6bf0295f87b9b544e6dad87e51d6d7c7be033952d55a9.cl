//{"bestFeatures":6,"bestThresholds":7,"entropies":8,"histogram":0,"nClasses":4,"nFeatures":2,"nThresholds":3,"perClassTotSamples":1,"perThreadFeatThrPairs":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void learnBestFeature(global unsigned int* histogram, global unsigned int* perClassTotSamples, unsigned int nFeatures, unsigned int nThresholds, unsigned int nClasses, unsigned int perThreadFeatThrPairs, global unsigned int* bestFeatures, global unsigned int* bestThresholds, global float* entropies) {
  float tmp, h, hL, hR, currBestEntropy;
  int offset, nL, nR, currBestFeature, currBestThreshold;
  int nodeID, featureID, thrID;

  currBestFeature = get_global_id(0);
  currBestThreshold = 0;

  for (int i = 0; i < perThreadFeatThrPairs; i++) {
    h = 0.0f;
    hL = 0.0f;
    hR = 0.0f;
    nL = 0;
    nR = 0;

    offset = get_global_id(0) * perThreadFeatThrPairs + i;
    nodeID = offset / (nFeatures * nThresholds);

    thrID = (offset % (nFeatures * nThresholds)) / nFeatures;
    featureID = offset % nFeatures;

    for (int l = 0; l < nClasses; l++) {
      offset = nodeID * (nClasses * nThresholds * nFeatures) +

               l * (nThresholds * nFeatures) + thrID * (nFeatures) + featureID;
      nL += histogram[hook(0, offset)];
      nR += perClassTotSamples[hook(1, nodeID * nClasses + l)] - histogram[hook(0, offset)];
    }

    for (int l = 0; l < nClasses; l++) {
      offset = nodeID * (nClasses * nThresholds * nFeatures) +

               l * (nThresholds * nFeatures) + thrID * (nFeatures) + featureID;

      tmp = ((float)perClassTotSamples[hook(1, nodeID * nClasses + l)]) / (nL + nR);
      h -= (tmp <= (1.e-6)) ? 0.0f : tmp * log2(tmp);

      tmp = (nL) ? (float)histogram[hook(0, offset)] / nL : 0.0f;
      hL -= (tmp <= (1.e-6)) ? 0.0f : tmp * log2(tmp);

      tmp = (nR) ? (float)(perClassTotSamples[hook(1, nodeID * nClasses + l)] - histogram[hook(0, offset)]) / nR : 0.0f;
      hR -= (tmp <= (1.e-6)) ? 0.0f : tmp * log2(tmp);
    }
    tmp = h - ((float)nL / (nL + nR) * hL + (float)nR / (nL + nR) * hR);

    if (!i || tmp > currBestEntropy) {
      currBestEntropy = tmp;
      currBestFeature = featureID;
      currBestThreshold = thrID;
    }
  }

  bestFeatures[hook(6, get_global_id(0))] = currBestFeature;
  bestThresholds[hook(7, get_global_id(0))] = currBestThreshold;
  entropies[hook(8, get_global_id(0))] = currBestEntropy;
}