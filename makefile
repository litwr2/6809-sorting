CFLAGS = -O3
checksort: checksort.o 6809sim/6809.o 6809sim/monitor.o
checksort.o: checksort.c data.h
6809sim/6809.o: 6809sim/6809.c
6809sim/monitor.o: 6809sim/monitor.c
insertion selection shell radix8 quick:
	./compile check$@.asm
	make
	./checksort out.bin
clean:
	rm *.o 6809sim/*.o checksort out.* data.h
