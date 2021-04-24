import os, sys
import edalize

work_root = 'build'

def src_entry(src):
    return {'name' : os.path.relpath(src, work_root), 'file_type' : 'verilogSource'}


if __name__ == "__main__":
    src_files = []

