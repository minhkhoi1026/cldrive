//{"matFinale":1,"matInit":0,"nombreColonnes":3,"nombreLignes":2,"nombrePasTemps":4,"tailleSubdivision":6,"tempsDiscretise":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calculateMatrix(global float* matInit, global float* matFinale, const float nombreLignes, const float nombreColonnes, const float nombrePasTemps, const float tempsDiscretise, const float tailleSubdivision) {
  int globalID = get_global_id(0);
  int nombreLines = (int)nombreLignes;
  int nombreCol = (int)nombreColonnes;

  float formuleP1 = 0;
  float formuleP2 = 0;
  float formuleP3 = 0;

  if (globalID < nombreLines * nombreCol) {
    if ((globalID < nombreLignes) || (globalID % (int)nombreLignes) == 0 || (globalID >= ((nombreLines * nombreCol) - nombreLines)) || (((globalID - nombreLines) + 1) % (int)nombreLignes) == 0) {
      matFinale[hook(1, globalID)] = 0.0;
    } else {
      formuleP1 = (1 - (4 * tempsDiscretise / tailleSubdivision * tailleSubdivision)) * matInit[hook(0, globalID)];
      formuleP2 = (tempsDiscretise / tailleSubdivision * tailleSubdivision);
      formuleP3 = matInit[hook(0, globalID - nombreLines)] + matInit[hook(0, globalID + nombreLines)] + matInit[hook(0, globalID - 1)] + matInit[hook(0, globalID + 1)];
      matFinale[hook(1, globalID)] = formuleP1 + (formuleP2 * formuleP3);
    }
  }
}