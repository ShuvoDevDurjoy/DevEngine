# Makefile for template_engine

CXX = g++
CXXFLAGS = -std=c++17

SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = .

SRC_FILES = $(SRC_DIR)/main.cpp $(SRC_DIR)/TemplateEngine.cpp
OBJ_FILES = $(OBJ_FILES:.cpp=.o)

# Output executable name
TARGET = dev

# Default target: compile everything
all: $(TARGET)

$(TARGET): $(SRC_FILES)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRC_FILES)

# Clean target: removes object files and executable
clean:
	rm -f $(OBJ_DIR)/*.o $(TARGET)
