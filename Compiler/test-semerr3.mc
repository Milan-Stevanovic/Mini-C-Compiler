// TEST SEMANTIC ERROR 3
int main()
{
	int a, b, c;
	unsigned d, e;
	
	unsigned a, b, c; // ERROR [REDEFINITION]
	int d, e;         // ERROR [REDEFINITION]
	
	a = 1;
	b = 2;
	c = 3;
	d = 4u;
	e = 5u;
	
	return 0;
}
