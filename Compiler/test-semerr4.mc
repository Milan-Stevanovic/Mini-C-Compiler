// TEST SEMANTIC ERROR 4
int main()
{
	int a, b, c;
		
	a = 0;
	b = 0;
	c = 0;
	
	a++;
	a = b + c++ - 5;
	
	main++; // ERROR [CANNOT INCREMENT FUNCTION]
		
	return 0;
}
