#include "verilated.h"
#include "CppUTest/CommandLineTestRunner.h"

// IMPORT_TEST_GROUP(ModuleNameGroup);

int main(int argc, char** argv)
{
    Verilated::commandArgs(argc, argv);
    MemoryLeakWarningPlugin::turnOffNewDeleteOverloads();

    return RUN_ALL_TESTS(argc, argv);
}
