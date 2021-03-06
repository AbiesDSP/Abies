#include "verilated.h"
#include "CppUTest/CommandLineTestRunner.h"

IMPORT_TEST_GROUP(AbiesTopGroup);
IMPORT_TEST_GROUP(SramArbiterGroup);
IMPORT_TEST_GROUP(PwmGroup);
IMPORT_TEST_GROUP(FirGroup);
IMPORT_TEST_GROUP(I2SGroup);
IMPORT_TEST_GROUP(FifoGroup);
IMPORT_TEST_GROUP(DdsGroup);

int main(int argc, char** argv)
{
    Verilated::commandArgs(argc, argv);

    MemoryLeakWarningPlugin::turnOffNewDeleteOverloads();

    return RUN_ALL_TESTS(argc, argv);
}
