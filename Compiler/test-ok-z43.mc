//OPIS: post incr u rel_exp i obican post incr
//RETURN: 7

int main() {
  int a;
  int b;
  a = 5;
  b = 5;
  
  if(a++ > b)
  	a++;
  else
  	b++;
  
  a++;
  
  return a;
}

