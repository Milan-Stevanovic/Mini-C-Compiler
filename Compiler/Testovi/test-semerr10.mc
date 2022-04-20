// TEST SEMANTIC ERROR 10
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
	return b;
}

int main()
{	
	int a;
	unsigned b;
	
	a = funkcija1(1, 2, 3, 4);          // ERROR [WRONG NUMBER OF PARAMETERS]
	b = funkcija2(1, 2, k, 4u, 5u);     // ERROR [ARGUMENT [k] UNDECLARED]
	b = funkcija2(1, 2u, 3, 4, 5u);     // ERROR [WRONG ORDER OF PARAMETERS]
											/* error 'WRONG ORDER' ce se ponoviti onoliko puta koliko
											 koliko pogresnih parametara ima u funkciji)*/
	funkcija3(1, 2u, 3u);               // ERROR [WRONG ORDER OF PARAMETERS]
	a = funkcija4(a);                   // ERROR [INCOMPATIBLE TYPE OF ATGUMENT]
	
	return 0;
}
