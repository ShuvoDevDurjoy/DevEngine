#!/bin/bash

# Project setup directory
PROJECT_DIR="template_engine"

# Create the main project directory if it doesn't exist
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Creating project directory: $PROJECT_DIR"
    mkdir "$PROJECT_DIR"
    cd "$PROJECT_DIR"

    # Create necessary subdirectories
    mkdir build include src templates

    # Create the source code files
    echo "Creating source files..."

    # Create src/main.cpp with corrected paths
    cat > src/main.cpp << EOF
#include "../include/TemplateEngine.hpp"  // Corrected include path
#include <iostream>
#include <cstdlib>
#include <filesystem>

namespace fs = std::filesystem;

void printUsage() {
    std::cout << "Usage: dev <template_file> [--compile]" << std::endl;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printUsage();
        return 1;
    }

    std::string templateFile = argv[1];
    bool compileAndRun = false;

    if (argc > 2 && std::string(argv[2]) == "--compile") {
        compileAndRun = true;
    }

    if (!fs::exists(templateFile)) {
        std::cerr << "Template file not found: " << templateFile << std::endl;
        return 1;
    }

    try {
        TemplateEngine engine(templateFile);
        std::string outputFileName = "generated_output.cpp";
        engine.renderAndSave(outputFileName);

        if (compileAndRun) {
            std::cout << "Compiling and running the generated file..." << std::endl;
            std::string command = "g++ " + outputFileName + " -o generated_output && ./generated_output";
            system(command.c_str());
        }

    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}
EOF

    # Create src/TemplateEngine.cpp with corrected paths
    cat > src/TemplateEngine.cpp << EOF
#include "../include/TemplateEngine.hpp"  // Corrected include path
#include <fstream>
#include <sstream>
#include <iostream>

TemplateEngine::TemplateEngine(const std::string& file) {
    std::ifstream inputFile(file);
    if (!inputFile) {
        throw std::runtime_error("Failed to open template file.");
    }
    std::stringstream buffer;
    buffer << inputFile.rdbuf();
    content = buffer.str();
}

void TemplateEngine::renderAndSave(const std::string& outputFile) {
    std::ofstream outFile(outputFile);
    if (!outFile) {
        throw std::runtime_error("Failed to open output file.");
    }

    std::string renderedContent = content;
    size_t pos = 0;

    while ((pos = renderedContent.find("{{", pos)) != std::string::npos) {
        size_t endPos = renderedContent.find("}}", pos);
        if (endPos == std::string::npos) {
            throw std::runtime_error("Mismatched {{ }} in template.");
        }
        renderedContent.replace(pos, 2, "std::cout <<\"");
        endPos += 11;
        renderedContent.replace(endPos, 2, "\"<<std::endl");
        pos = endPos + 10;
    }

    std::cout<<renderedContent<<std::endl;

    // Handle \${ } replacement for variables
    pos = 0;
    while ((pos = renderedContent.find("\${", pos)) != std::string::npos) {
        size_t endPos = renderedContent.find("}", pos);
        if (endPos == std::string::npos) {
            throw std::runtime_error("Mismatched \${ } in template.");
        }

        // Extract the variable name
        renderedContent.replace(pos, 2, "\"<<");
        endPos += 1;
        renderedContent.replace(endPos, 1, "<<\"");
        pos = endPos + 2;

    }
    outFile << renderedContent;
}
EOF

    # Create include/TemplateEngine.hpp
    cat > include/TemplateEngine.hpp << EOF
#ifndef TEMPLATE_ENGINE_HPP
#define TEMPLATE_ENGINE_HPP

#include <string>

class TemplateEngine {
public:
    explicit TemplateEngine(const std::string& file);
    void renderAndSave(const std::string& outputFile);

private:
    std::string content;
};

#endif // TEMPLATE_ENGINE_HPP
EOF

    # Create the template file
    mkdir -p templates
    cat > templates/hello.dev.cpp << EOF
#include <iostream>
using namespace std;

int main() {
    string name = "John";
    int age = 25;

    {{ Hello, \${ name }. You are \${ age } years old. }};  // Corrected template syntax
    return 0;
}
EOF

    # Create the Makefile
    cat > Makefile << EOF
# Makefile for template_engine

CXX = g++
CXXFLAGS = -std=c++17

SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = .

SRC_FILES = \$(SRC_DIR)/main.cpp \$(SRC_DIR)/TemplateEngine.cpp
OBJ_FILES = \$(OBJ_FILES:.cpp=.o)

# Output executable name
TARGET = dev

# Default target: compile everything
all: \$(TARGET)

\$(TARGET): \$(SRC_FILES)
	\$(CXX) \$(CXXFLAGS) -o \$(TARGET) \$(SRC_FILES)

# Clean target: removes object files and executable
clean:
	rm -f \$(OBJ_DIR)/*.o \$(TARGET)
EOF

    echo "Project initialized. Now you can build the project using 'make'."

else
    echo "Project already initialized."
fi

# Build the project using make
echo "Building the project..."
make

# Move the 'dev' command to /usr/local/bin to make it globally available
if [ -f "dev" ]; then
    echo "Making 'dev' command global..."
    sudo mv dev /usr/local/bin/
    echo "'dev' command is now globally available. You can run it from anywhere."
else
    echo "Build failed, 'dev' not found."
fi
