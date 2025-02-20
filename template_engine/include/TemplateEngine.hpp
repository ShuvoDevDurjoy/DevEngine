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
