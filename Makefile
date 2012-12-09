DT_PATH=$(HOME)/DCPUToolchain

CC=$(DT_PATH)/dtcc
ASM=$(DT_PATH)/dtasm
LD=$(DT_PATH)/dtld
EMU=$(DT_PATH)/dtemu

TARGET=admiral

all: $(TARGET).bin

run: $(TARGET).bin
	# Emulate the final output
	$(EMU) $(TARGET).bin

$(TARGET).bin: $(TARGET).dasm16
	$(ASM) -o $@ -s $@.s $(TARGET).dasm16

clean:
	rm -fv *.bin *.s *~

