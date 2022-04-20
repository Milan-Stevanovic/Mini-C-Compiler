// TEST SEMANTIC ERROR 2 POJEDINACNI
int main()
{	
	% haihou %
		a = a + 3; // ERROR [VARIABLE [a] UNDECLARED]
		a++;
	% hiki a < 10 %;
	
	return 0;
}
