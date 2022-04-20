//OPIS: mnozenje i deljenje sa prioritetom
//RETURN: 10

int main() {
	int a;
	int b;
	int c;
	int d;
	
	a = 2;
	b = 3;
	c = 6;
	d = 3;
	
	b = a++ * b + c / d++ - a + a++ * b / c++ + b + c / d;

	return b;
}
