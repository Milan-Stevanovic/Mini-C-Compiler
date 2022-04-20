//OPIS: TEST 10 OK [POZIV FUNKCIJA SA VISE PARAMETARA]
//RETURN: 18
int funkcija1(int a, int b, int c)
{
	int rez;
	rez = a + b + c;
	return rez;
}

unsigned funkcija2(int a, int b, int c, unsigned d, unsigned e)
{
	int intRez;
	unsigned unsignedRez;
	intRez = a + b + c;
	unsignedRez = d * e;
	return unsignedRez;
}

void funkcija3(int a, unsigned b, int c)
{
	a++;
	b++;
	c++;
}

int funkcija4(unsigned a)
{
	int b;
	return 15;
}

int main()
{	
	int a, c;
	unsigned b;
	
	a = funkcija1(1, 2, 3);
	a = funkcija1(a, a, a);
	b = funkcija2(1, 2, 3, 4u, 5u);
	funkcija3(1, 2u, 3);
	c = funkcija4(b);
	
	return a;
}
