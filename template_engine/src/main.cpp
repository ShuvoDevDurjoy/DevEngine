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
