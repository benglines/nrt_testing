CC = gcc
CFLAGS = -I/opt/aws/neuron/include -pthread
LDFLAGS = -L/opt/aws/neuron/lib -lnrt
TARGET = peek_neuron_cores
SRC = peek_neuron_cores.c

$(TARGET): $(SRC)
	$(CC) $(SRC) -o $(TARGET) $(CFLAGS) $(LDFLAGS)

clean:
	rm -f $(TARGET)
