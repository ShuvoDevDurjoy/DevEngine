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

    // Handle ${ } replacement for variables
    pos = 0;
    while ((pos = renderedContent.find("${", pos)) != std::string::npos) {
        size_t endPos = renderedContent.find("}", pos);
        if (endPos == std::string::npos) {
            throw std::runtime_error("Mismatched ${ } in template.");
        }

        // Extract the variable name
        renderedContent.replace(pos, 2, "\"<<");
        endPos += 1;
        renderedContent.replace(endPos, 1, "<<\"");
        pos = endPos + 2;

    }
    outFile << renderedContent;
}
