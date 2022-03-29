#include <stdio.h>
#include <string.h>

int main(int argc, char *word[]) {
	// Initializing the variables
	int i, j, count;
	// Initializing and assigning each word
	char *word1 = word[1];
	char *word2 = word[2];

	// Iterating through each letter in the first word
	for (i = 0; i < strlen(word1) && strlen(word1) == strlen(word2); i++) {
		// Iterating through the second word to find a match
		for (j = 0; j < strlen(word2); j++) {
			if (word1[i] == word2[j]) {
				word2[j] = '0';
				count++;
				break;
			}
		}
	}

	if (strlen(word1) == count) {
		printf("Anagram\n");
		return 0;
	}
	printf("Not an anagram\n");
	return 1;

}
