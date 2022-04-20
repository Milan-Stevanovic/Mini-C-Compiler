// TEST SEMANTIC ERROR 9
int fun1(int a) // OK
{
	return a;
}

int fun2(int a) // WARNING [FUNCTION MUST RETURN VALUE]
{
	return ;
}

int fun3(int a) // WARNING [FUNCTION MUST RETURN VALUE]
{
	
}

void fun4(int a) // ERROR [VOID FUNCTION CANNOT HAVE RETURN STATEMENT]
{
	return a;
}

void fun5(int a) // OK
{
	return ;
}

void fun6(int a) // OK
{
	
}

int main()
{	
	int a, b, c;
	
	// Int functions
	a = fun1(1);
	b = fun2(2);
	c = fun3(3);
	
	// Void functions
	fun4(4);
	fun5(5);
	fun6(6);
	
	return 0;
}
