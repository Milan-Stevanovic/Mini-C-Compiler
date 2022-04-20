//OPIS: TEST 2 POJEDINACNI OK [ HAIHHOU HIKI ]
//RETURN: 96
int main()
{	
	int a, b, c, d;
	
	a = 0;
	b = 0;
	c = 0;
	d = 0;
	
	// Standardan HAOHOU-HIKI Statement
	% haihou %
		a = a + 3;
		a++;
	% hiki a < 10 %;
	
	// Ugnjezden HAOHOU-HIKI Statement
	% haihou %
		% haihou %
			% haihou %
				d = d + 3;
				d++;
			% hiki d < 10 %;
			c++;
		% hiki c < 10 %;
		b++;
	% hiki b < 10 %;
	
	return a + d;
}
