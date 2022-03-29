#include <stdio.h>

int main(void)
{
	int a, b, c;
	// Asking for user input
	printf("Please input three numbers: ");
	scanf("%d %d %d", &a, &b, &c);

	// If the numbers are increasing
	if (c > b && b > a) {
		// If a is non-zero (for division by zero errors) and b and c are divisible by a
		if (a != 0 && b % a == 0 && c % a == 0) {
			printf("Divisible & Increasing\n");
			return 0;
		 // If a = 0 or b and c are not divisible by a
		} else {
			printf("Not divisible & Increasing\n");
			return 1;

		}
	// If the numbers are not increasing
	} else {
		// Checking for a != 0 and divisibility once again
		if (a != 0 && b % a == 0 && c % a == 0) {
			printf("Divisible & Not increasing\n");
			return 2;
		// If a = 0 or b and c are not divisible by a
		} else {
			printf("Not divisible & Not increasing\n");
			return 3;
		}
	
	}

}
