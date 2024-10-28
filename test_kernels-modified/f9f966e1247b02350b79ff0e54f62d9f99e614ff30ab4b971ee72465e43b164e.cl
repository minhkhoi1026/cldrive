//{"A":0,"N":1,"hauteur":3,"largeur":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mandelbrot(global int* A, const int N, const int largeur, const int hauteur) {
  int idx = get_global_id(0);

  int y = idx / hauteur;
  int x = idx - (y * largeur);

  if (y >= hauteur || x >= largeur)
    return;
  else {
    int cpt = 0;
    float x1 = 0.f;
    float y1 = 0.f;

    float x2 = 0.f;
    float y2 = 0.f;
    float a = 4.f * x / largeur - 2.f;
    float b = 4.f * y / hauteur - 2.f;

    float val = x1 * x1 + y1 * y1;

    while (cpt < N && val <= 4.f) {
      cpt++;
      x2 = x1 * x1 - y1 * y1 + a;
      y2 = 2.f * x1 * y1 + b;
      x1 = x2;
      y1 = y2;
      val = x1 * x1 + y1 * y1;
    }

    A[hook(0, y * hauteur + x)] = cpt;
  }
}