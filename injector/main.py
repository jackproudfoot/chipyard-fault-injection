import os
import re
import sys
from mapping import Module

'''
Create list of modules from some input file
'''
def parse_file(file_path):
    #file = open(file_path, 'r')
    file = open(os.path.join(sys.path[0], file_path), 'r')      
    text = file.read()
    file.close()

    module_texts = re.findall(r'(module\s+(\w+)\(.+?endmodule)', text, re.DOTALL)
    print("num modules: " + str(len(module_texts)))
    all_modules = []
    for m_t in module_texts:
        new_module = Module(m_t[1], m_t[0])
        all_modules.append(new_module)
    
    # for m in all_modules:
    #     print(str(m))
    #     print("\n")
    return all_modules

if __name__ == '__main__':
    
    parse_file('chipyard.TestHarness.SmallBoomConfig.top.v')        #should be 475 modules

