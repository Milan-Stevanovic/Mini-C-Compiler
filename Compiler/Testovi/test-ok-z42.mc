//OPIS: branch test
//RETURN: 18	

int main() {
	int a;
	int b;
	int c;
	
	a = 1;
	b = 3;
	c = 5;
	
	branch ( a ; 1 , 3 , 5 )
		one -> a = a + 1;
		two -> a = a + 3;
		three -> a = a + 5;
		other -> a = a - 3;
	end_branch
	
	branch ( b ; 1 , 3 , 5 )
		one -> b = b + 1;
		two -> b = b + 3;
		three -> b = b + 5;
		other -> b = b - 3;
	end_branch

	branch ( c ; 1 , 3 , 5 )
		one -> c = c + 1;
		two -> c = c + 3;
		three -> c = c + 5;
		other -> c = c - 3;
	end_branch
	
	//  2 + 6 + 10
	c = a + b + c;
	
	return c;
}
