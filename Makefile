CC=clang
CFLAGS=-framework Foundation -framework CoreGraphics -framework AppKit -fobjc-arc -Wall
TARGET=spacespy

all: $(TARGET)

$(TARGET): $(TARGET).m
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(TARGET)