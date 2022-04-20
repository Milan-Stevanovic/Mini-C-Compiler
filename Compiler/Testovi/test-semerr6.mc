// TEST SEMANTIC ERROR 6
int funkcija1(int a)
{
	unsigned a; // ERROR [REDEFINITION]
	return a + 1;
}

int funkcija2(int a)
{
	unsigned a; // ERROR [REDEFINITION]
	return a - 1;
}

int main()
{
	int a, b, c;
	unsigned d, e;
	
	unsigned a; // ERROR [REDEFINITION]
	
	return 0;
}
