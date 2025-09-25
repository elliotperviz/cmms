#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <ctype.h>

#define MAX_LINE_LENGTH 1024	// Maximum line length
#define MAX_COLUMNS 100 	// Maximum number of columns to handle

void move_window(double *window, int size);
int is_number(const char *str);

int main(int argc, char *argv[]) {

	if (argc != 6) {
		fprintf(stderr, "Usage: %s <input_file> <output_file> <window_size> <step_col_id> <col_to_avg_id>\n", argv[0]);
		return 1;
	}

	char *input_filename = argv[1];
	char *output_filename = argv[2];
	int window_size = atoi(argv[3]);
	int step_col_id = atoi(argv[4]);
	int temp_col_id = atoi(argv[5]);

	step_col_id -= 1;
	temp_col_id -= 1;

	FILE *input_file, *output_file;
    	int i = 0, count = 0, column_count = 0, step;
    	double sum = 0.0, sum_sq = 0.0, temperature, moving_avg, stddev;
    	double *temp_window;
    	char line[MAX_LINE_LENGTH];
    
    	// Open input and output files
    	input_file = fopen(input_filename, "r");
    	output_file = fopen(output_filename, "w");
    
    	if (input_file == NULL || output_file == NULL) {
    		fprintf(stderr, "Error opening file.\n");
        	return 1;
    	}

	// Allocate memory for temp_window dynamically
	temp_window = (double *)malloc(window_size * sizeof(double));
    	if (temp_window == NULL) {
        	fprintf(stderr, "Memory allocation failed.\n");
        	fclose(input_file);
        	fclose(output_file);
        	return 1;
    	}

    	// Initialize temp_window array
    	for (i = 0; i < window_size; i++) {
    		temp_window[i] = 0.0;
	}

	char *token;
	char temp_line[MAX_LINE_LENGTH];

	// Read the first line
	if (fgets(line, sizeof(line), input_file) == NULL) {
		fprintf(stderr, "Error: Empty file.\n");
		fclose(input_file);
		fclose(output_file);
		return 1;
	}

	strcpy(temp_line, line); // Make a copy for tokenizing
	token = strtok(temp_line, " \t");

	int col_idx = 0;
	char *values[MAX_COLUMNS];

	while (token != NULL && col_idx < MAX_COLUMNS) {
		values[col_idx++] = token;
		token = strtok(NULL, " \t");
	}

	// Check if step and temperature columns contain valid numbers
        if (!is_number(values[step_col_id]) || !is_number(values[temp_col_id])) {
                fprintf(stderr, "Detected a header line. Reading the next line.\n");

                // Read second line (actual data)
                if (fgets(line, sizeof(line), input_file) == NULL) {
                        fprintf(stderr, "Error: No data lines found after header.\n");
                        fclose(input_file);
                        fclose(output_file);
                        return 1;
                }

                strcpy(temp_line, line); // Copy again for processing
                col_idx = 0;
                token = strtok(temp_line, " \t");

                while (token != NULL && col_idx < MAX_COLUMNS) {
                        values[col_idx++] = token;
                        token = strtok(NULL, " \t");
                }
        }

	// Set column count based on the first actual data line
        column_count = col_idx;

	// Validate provided column indices
        if (step_col_id >= column_count || temp_col_id >= column_count) {
                fprintf(stderr, "Error: Specified column indices exceed available columns (%d detected).\n", column_count);
                fclose(input_file);
                fclose(output_file);
                return 1;
        }
	
	// Assign values from the identified first data line
        step = atof(values[step_col_id]);
        temperature = atof(values[temp_col_id]);
        temp_window[count] = temperature;
        sum += temperature;
        sum_sq += temperature * temperature;
        count++;

    	// Process remaining lines
    	while (fgets(line, sizeof(line), input_file) != NULL) {
		char *values[MAX_COLUMNS];
		int col_idx = 0;
		char temp_line[MAX_LINE_LENGTH];

		strcpy(temp_line, line);  // Make a copy since strtok modifies the string
        	char *token = strtok(temp_line, " \t");

		while (token != NULL && col_idx < column_count) {
            		values[col_idx++] = token;
            		token = strtok(NULL, " \t");
        	}

        	if (col_idx < column_count) {
            		fprintf(stderr, "Warning: Skipping malformed line: %s", line);
            		continue;
        	}

		step = atoi(values[step_col_id]);
        	temperature = atof(values[temp_col_id]);

        	// Update window and calculate sum and sum_sq
        	if (count < window_size) {
            		temp_window[count] = temperature;
            		sum += temperature;
            		sum_sq += temperature * temperature;
	    		count++;
        	} else {
            		sum -= temp_window[0];
            		sum_sq -= temp_window[0] * temp_window[0];
            		move_window(temp_window, window_size);
            		temp_window[window_size - 1] = temperature;
            		sum += temperature;
            		sum_sq += temperature * temperature;
        	}
        
		// When the window is full, calculate moving average and standard deviation
        	if (count == window_size) {
        		moving_avg = sum / window_size;
            		stddev = sqrt((sum_sq / window_size) - moving_avg * moving_avg);

	    		// Write step, moving average, and stddev to output_file
			fprintf(output_file, "%d %.5lf %.5lf\n", step, moving_avg, stddev);
		}
	}	

    	fclose(input_file);
    	fclose(output_file);

    	return 0;
}

void move_window(double *window, int size) {
    for (int i = 0; i < size - 1; i++) {
        window[i] = window[i + 1];
    }
}


// Function to check if a string is a valid number
int is_number(const char *str) {
    if (str == NULL || *str == '\0') return 0;
    
    char *endptr;
    strtod(str, &endptr);
    
    return (*endptr == '\0' || isspace(*endptr));
}

