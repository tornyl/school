
#define PI 3.14159265359
float objem_valce(float polomer, float vyska){
	return PI * polomer * polomer * vyska;
}

float povrch_valce(float polomer, float vyska){
	return 2 * PI * polomer * vyska + 2 * PI * polomer * polomer;
}

float objem_trojbok(float podstava, float v){
		return podstava * v;	
}
float podstava_trojbok(float a, float va){
	return a * va * 0.5;
}

float povrch_trojbok(float podstava, float strana){
	return 2 * podstava + 3 * strana;
}

float obsah_strany_trojbok(float a, float v){
	return a * v;
}


float objem_ctyrbok(float podstava, float v){
		return podstava * v;	
}
float podstava_ctyrbok(float a, float va){
	return a * va;
}

float povrch_ctyrbok(float podstava, float strana){
	return 2 * podstava + 4 * strana;
}

float obsah_strany_ctyrbok(float a, float v){
	return a * v;
}
