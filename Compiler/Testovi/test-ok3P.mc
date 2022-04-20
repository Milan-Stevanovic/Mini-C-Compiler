//OPIS: TEST 3 POJEDINACNI OK [BRANCH]
//RETURN: 17
int main()
{	
	int a;
	int b;
	
	a = 10;
	
	branch ( a ; 1 , 3 , 5 )
		one -> a = a + 1;
		two -> a = a + 3;
		three -> a = a + 5;
		other -> a = a - 3;
	end_branch
	
	b = 5;
	
	branch ( b ; 1 , 3 , 5 )
		one -> b = b + 1;
		two -> b = b + 3;
		three -> b = b + 5;
		other -> b = b - 3;
	end_branch
	
	return a + b;
}
