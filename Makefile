CXX      := g++
CXXFLAGS := -pedantic-errors -Wno-sign-compare -Wno-unknown-pragmas -Wall -Wextra -Werror -std=c++17 -O3
LDFLAGS  := -L/opt/homebrew/lib -lstdc++ -lm -lz3
BUILD    := ./build
OBJ_DIR  := $(BUILD)/objects
APP_DIR  := $(BUILD)
TARGET   := fperf
INCLUDE  := -I/opt/homebrew/include -Ilib/ -Ilib/metrics/ -Ilib/cps -Ilib/qms
SRC      := $(wildcard src/*.cpp) $(wildcard src/*/*.cpp)
TEST_SRC := $(wildcard tests/*.cpp)
TEST_TARGET_PATH := $(APP_DIR)/$(TARGET)_test

HEADERS := $(patsubst src/%.cpp,lib/%.hpp, $(filter-out src/main.cpp, $(SRC)))
OBJECTS := $(patsubst %.cpp,$(OBJ_DIR)/%.o,$(SRC))

all: build $(APP_DIR)/$(TARGET)

$(OBJ_DIR)/%.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

$(APP_DIR)/$(TARGET): $(OBJECTS)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $^ 

.PHONY: all build clean test check-format format

build:
	@mkdir -p $(APP_DIR)
	@mkdir -p $(OBJ_DIR)

run:
	./$(APP_DIR)/$(TARGET)

$(TEST_TARGET_PATH): $(OBJECTS) $(TEST_SRC)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -o $@ $(TEST_SRC) $(filter-out ./build/objects/src/main.o, $(OBJECTS)) $(LDFLAGS)

test: $(TEST_TARGET_PATH)
	$^

check-format: $(HEADERS) $(SRC)
	clang-format --dry-run -Werror $^

format: $(HEADERS) $(SRC)
	clang-format -i $^

clean:
	-@rm -rvf $(OBJ_DIR)/*
	-@rm -rvf $(APP_DIR)/*
