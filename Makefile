# GCC options
CC = gcc
CFLAGS = -Ofast -g -std=c99 -fopenmp -w # -pedantic -Wall    <-- pedantic and Wall have been left out so we dont have 5000 warnings, if necessary, just enable again and remove -w
#CFLAGS = -Kfast -std=c99 
LDFLAGS = -lm

#Debug options
#CFLAGS = -g -Og -std=c99 -pedantic -fsanitize=undefined -fsanitize=address

# Intel icc compiler
#CC = icc
#CFLAGS = -restrict -Ofast -std=c99 -pedantic
#LDFLAGS =

# Clang options
#CC = clang
#CFLAGS = -Ofast -std=c99 -pedantic
#LDFLAGS = -lm

SRC_FOLDER = src
TMP_FOLDER = tmp

SOURCES = $(wildcard $(SRC_FOLDER)/*.c)
OBJECTS = $(patsubst $(SRC_FOLDER)/%.c,$(TMP_FOLDER)/%.o,$(SOURCES))

TARGET = zpic

DOCSBASE = docs
DOCS = $(DOCSBASE)/html/index.html
DOXYFILE = $(SRC_FOLDER)/Doxyfile 

all: $(TARGET)

$(TARGET): $(OBJECTS)
	@$(CC) $(CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@
	@echo -e "\n$(TARGET) compiled with:\n\tCC: $(CC)\n\tCFLAGS: $(CFLAGS)\n"

$(TMP_FOLDER)/%.o: $(SRC_FOLDER)/%.c | $(TMP_FOLDER)
	@$(CC) -c $(CFLAGS) -o $@ $<

$(TMP_FOLDER):
	@mkdir -p $(TMP_FOLDER)

OMP_NUM_THREADS ?= 16 # if not set, then set variable to 4
export OMP_NUM_THREADS
run: all
	@./$(TARGET)

scorep: CC = scorep gcc
scorep: all

docs: $(DOCS)

$(DOCS): 
	@doxygen $(DOXYFILE)

clean:
	@rm -f $(TARGET)
	@rm -rf $(TMP_FOLDER)
	@rm -rf $(TMP_SCOREP)
	@rm -rf $(DOCSBASE)
	@echo "Cleaning..."

re: clean all
rep: clean scorep
