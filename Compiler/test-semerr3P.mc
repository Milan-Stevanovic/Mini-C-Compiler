// TEST SEMANTIC ERROR 3 POJEDINACNO
int main()
{
	int a;
	branch ( a ; 1 , 3 , 5 )
		one -> a = a + 1;
		two -> a = a + 3u;   // ERROR [CANNOT ADD UNISIGNED VALUE TO INT]
		three -> a = a + 5;
		other -> a = a - 3;
	end_branch
	
	branch ( b ; 1 , 3 , 5 ) // ERROR [VARIABLE [b] UNDECLARED]
		one -> a = a + 1;
		two -> a = a + 3;
		three -> a = a + 5;
		other -> a = a - 3;
	end_branch
	
	return 0;
}
