//OPIS: conditional (uslovni) izraz #2
//RETURN: 11

int main() {
  int a;
  int b;
  a = 5;
  b = 3;
  
  a = a + (a == b) ? a : b + 3;
  
  return a;
}

