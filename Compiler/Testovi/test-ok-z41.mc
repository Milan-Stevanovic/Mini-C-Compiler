//OPIS: ugnjezden i neugnjezden haihou-hiki
//RETURN: 152	

int main() {
	int a;
	int b;
	int c;
	int d;
	
	a = 0;
	b = 0;
	c = 0;
	d = 0;
	
	% haihou %
		a++;
	% hiki a < 10 %;
	
	% haihou %
		% haihou %
			% haihou %
				% haihou %
					a = a + 3;
					a++;
				% hiki a < 10 %;
				b++;
			% hiki b < 11 %;
			c++;
		% hiki c < 12 %;
		d++;
	% hiki d < 13 %;
	
	% haihou %
		a++;
	% hiki a < 10 %;
	
	% haihou %
		% haihou %
			% haihou %
				% haihou %
					a = a + 3;
					a++;
				% hiki a < 10 %;
				b++;
			% hiki b < 11 %;
			c++;
		% hiki c < 12 %;
		d++;
	% hiki d < 13 %;
	
	% haihou %
		a++;
	% hiki a < 10 %;
	
	return a;
}
