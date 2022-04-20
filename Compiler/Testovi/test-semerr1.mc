// TEST SEMANTIC ERROR 1
int function(int par)
{
	int a;
	a = 3;
	
	return a + par;	
}

unsigned function(int par)  // ERROR [REDEFINITION]
{
	return par;	
}

int main()
{
	/*
		Testiranje viselinijskog komentara!
	*/
	int a;
	int c, d, e;
	unsigned b;
	unsigned f, g, h;
	
	unsigned a; // ERROR [REDEFINITION]
	
	// Testiranje jednolinijskog komentara!
	 
	a = 5u;    // ERROR [INCOMPATIBLE TYPES] 
	a = 5;
	b = 5u;
	c = 10;
	f = 10u;
	
	d = function(a);
	
	e = a + 5;
	g = b - 5u;
	
	if(a > c)
		c = c + a;
	else
		a = a + c;
	
	if(a != c)
	{
		a = a + 1;
	}
	
	if(a < c)
	{
		a = c * e;
	}
	
	if(f >= g)
	{
		h = g / f;
	}
}   // WARNING [NO RETURN]
