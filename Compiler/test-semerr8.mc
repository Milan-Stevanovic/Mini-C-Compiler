// TEST SEMANTIC ERROR 8
void funkcija1(int a)
{
	a++;
}

void funkcija2(unsigned a)
{
	a++;
}

int main()
{	
	int a;
	unsigned b;
	
	void c; // ERROR [VARIABLE CANNOT BE VOID TYPE]
	
	funkcija1(a);
	funkcija2(b);
	
	return 0;
}
