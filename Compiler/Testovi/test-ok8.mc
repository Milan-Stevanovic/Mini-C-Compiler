//OPIS: TEST 8 OK [ VOID - NEMA RETURN ]  
void funkcija1(int a)
{
	a++;
}

void funkcija2(unsigned a)
{
	a++;
}

void main()
{	
	int a;
	unsigned b;
	
	funkcija1(a);
	funkcija2(b);
}
