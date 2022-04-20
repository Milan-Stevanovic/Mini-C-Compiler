//OPIS: TEST 1 POJEDINACNI OK
//RETURN: 2
int main()
{	
	int a, b, c, d;
	
	a = 1;
	b = 2;
	c = 3;
	d = 4;
	
	a = a * b / c / d;
	a = a / b * (c / d);
	
	return a + b;
}
