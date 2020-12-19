#include "verilated.h"
#include "CppUTest/CommandLineTestRunner.h"

IMPORT_TEST_GROUP(Counter);
IMPORT_TEST_GROUP(Buffer);

int main(int argc, char** argv)
{
    Verilated::commandArgs(argc, argv);
    // CppUTest really complains about memory leaks..
    MemoryLeakWarningPlugin::turnOffNewDeleteOverloads();

    return RUN_ALL_TESTS(argc, argv);
}
