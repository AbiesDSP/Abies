// #include "verilated.h"
#include "CppUTest/CommandLineTestRunner.h"

// IMPORT_TEST_GROUP(CounterGroup);
// IMPORT_TEST_GROUP(BufferGroup);
IMPORT_TEST_GROUP(SramArbiterGroup);
IMPORT_TEST_GROUP(PwmGroup);
IMPORT_TEST_GROUP(FirGroup);

int main(int argc, char** argv)
{
    // Verilated::commandArgs(argc, argv);
    // CppUTest really complains about memory leaks..
    MemoryLeakWarningPlugin::turnOffNewDeleteOverloads();

    return RUN_ALL_TESTS(argc, argv);
}
