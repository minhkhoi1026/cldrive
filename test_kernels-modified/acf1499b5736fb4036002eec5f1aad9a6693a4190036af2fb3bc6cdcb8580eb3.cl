//{"A":0,"N":1,"hauteur":3,"largeur":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void game(global int* A, const int N, const int largeur, const int hauteur) {
  int idx = get_global_id(0);
  int y = idx / hauteur;
  int x = idx - (y * largeur);
  if (y >= hauteur || x >= largeur)
    return;

  int me = A[hook(0, idx)];
  int north = 0;
  int northEast = 0;
  int northWest = 0;
  int south = 0;
  int southEast = 0;
  int southWest = 0;
  int east = 0;
  int west = 0;
  if (x > 0)
    west = A[hook(0, idx - 1)];
  if (x < largeur - 1)
    east = A[hook(0, idx + 1)];
  if (y > 0)
    north = A[hook(0, idx - largeur)];
  if (y < hauteur - 1)
    south = A[hook(0, idx + largeur)];

  if ((y < hauteur - 1) && (x < largeur - 1))
    southEast = A[hook(0, idx + largeur + 1)];
  if ((y < hauteur - 1) && (x > 0))
    southWest = A[hook(0, idx + largeur - 1)];
  if ((y > 0) && (x > 0))
    northWest = A[hook(0, idx - largeur - 1)];
  if ((y > 0) && (x < largeur - 1))
    northEast = A[hook(0, idx - largeur + 1)];
  int res = north + south + east + west + northEast + northWest + southEast + southWest;

  if ((me == 1) && ((res < 2) || (res > 3)))
    A[hook(0, idx)] = 0;
  else if ((me == 0) && ((res == 3)))
    A[hook(0, idx)] = 1;
}