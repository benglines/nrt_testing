#include <nrt/nrt.h>

#include <getopt.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

extern char **environ;

static void fatal(char *err)
{
	fprintf(stderr, err);
	exit(1);
}

static void _print_neuron_env()
{
	printf("Printing NEURON* env vars...\n");
	for (char **env = environ; *env != NULL; env++) {
		if (strncmp(*env, "NEURON", 6) == 0) {
			printf("%d: %s\n", getpid(), *env);
		}
	}
	printf("Done printing NEURON* env vars.\n");
}

static void _print_neuron_cores()
{
	uint32_t total_nc_count = 0;
	uint32_t visible_nc_count = 0;

	if (nrt_get_total_nc_count(&total_nc_count) != NRT_SUCCESS)
		fatal("Failed to get total neuron core count");

	printf("%d: Total neuron core count:   %d\n", getpid(), total_nc_count);

	if (nrt_get_total_nc_count(&visible_nc_count) != NRT_SUCCESS)
		fatal("Failed to get visible neuron core count");

	printf("%d: Visible neuron core count: %d\n", getpid(),
	       visible_nc_count);
}

int main(int argc, char *argv[])
{
	bool do_block = false;
	int opt;

	static struct option long_opts[] = { { "block", no_argument, 0, 'b' },
					     { 0, 0, 0, 0 } };

	while ((opt = getopt_long(argc, argv, "b", long_opts, NULL)) != -1) {
		switch (opt) {
		case 'b':
			do_block = true;
			break;
		case '?':
		default:
			fprintf(stderr, "Usage: %s [--block|-b]\n", argv[0]);
			return 1;
		}
	}

	_print_neuron_env();

	if (nrt_init(NRT_FRAMEWORK_TYPE_NO_FW, "", "") != NRT_SUCCESS)
		fatal("Failed to init nrt");

	printf("%d: Finished nrt_init\n", getpid());
	_print_neuron_cores();

	/* Block while neuron cores are allocated to this process */
	if (do_block)
		pause();

	nrt_close();
}
