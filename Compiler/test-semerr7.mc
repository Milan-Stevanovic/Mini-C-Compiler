// TEST SEMANTIC ERROR 7
int main()
{
	int a, b;
	unsigned c, d;
	
	a = 0;
	b = 0;
	c = 0u;
	d = 0u;
	
	a++;
	b++;
	c++;
	d++;
	
	main++; // ERROR [CANNOT INCREMENT FUNCTION]
	
	return 0;
}
