//OPIS: TEST 6 OK [FUNKCIJE]
//RETURN: 5
int funkcija1(int a)
{
	return a + 1;
}

int funkcija2(int a)
{
	return a - 1;
}

int main()
{
	int a;
	
	a = funkcija1(5);
	a = funkcija2(a);
		
	return a;
}
