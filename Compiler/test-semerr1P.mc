// TEST SEMANTIC ERROR 1 POJEDINACNI
int main()
{	
	int a, b, c, d;
	unsigned e, f, g, h;
	
	a = a * b / c / i;       // ERROR [VARIABLE [i] UNDECLARED]
	a = a / b * (c / d);
	
	e = e * (f / g) + h;
	h = e / ((f / g) * h);
	
	a = e * b;               // ERROR [CANNOT MULTIPLY INT AND UNSIGNED TYPE]
	
	return 0;
}
