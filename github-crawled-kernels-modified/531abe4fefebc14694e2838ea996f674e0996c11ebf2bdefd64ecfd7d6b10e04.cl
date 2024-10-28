//{"currentPlayer":3,"firstPlayerHasWon":0,"illegalMove":2,"parasiteEnvironment":4,"whoHasWon":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_winner(global bool* firstPlayerHasWon, global int* whoHasWon, global bool* illegalMove, int currentPlayer, char parasiteEnvironment) {
  if (get_global_id(0) == 0) {
    if (*illegalMove) {
      if (currentPlayer == -1)
        *firstPlayerHasWon = false;
      else
        *firstPlayerHasWon = true;
    } else {
      if (*whoHasWon == 0) {
        if (parasiteEnvironment)
          *firstPlayerHasWon = false;
        else
          *firstPlayerHasWon = true;
      } else if (*whoHasWon == 1) {
        *firstPlayerHasWon = true;
      } else if (*whoHasWon == -1) {
        *firstPlayerHasWon = false;
      }
    }
  }
}