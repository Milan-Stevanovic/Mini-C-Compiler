//OPIS: TEST 9 OK [ POZIV VOID FUNKCIJE ]
//RETURN: 20
int fun1(int a) // OK
{
	return a;
}


void fun2(int a) // OK
{
	return ;
}

void fun3(int a) // OK
{
	
}

int main()
{	
	int a, b, c;
	
	// Int functions
	a = fun1(20);
	// Void functions
	fun2(4);
	fun3(5);
	
	return a;
}
