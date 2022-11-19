import os
import re
import sys
from Module import Module
from ModuleInstance import ModuleInstance
from ModuleTree import ModuleTree

all_modules = dict()    #module name to Module
faulty_modules = dict()     #module 
all_module_instances = dict()   # module name to list of ModuleInstances

'''
Create dict of all modules with module type as key from some input file
'''
def parse_file(file_path):
    file = open(os.path.join(sys.path[0], file_path), 'r')      
    text = file.read()
    file.close()

    module_texts = re.findall(r'(module\s+(\w+)\(.+?endmodule)', text, re.DOTALL)

    module_dict = dict()
    module_instance_dict = dict()

    for m_t in module_texts:
        new_module = Module(m_t[1], m_t[0])
        module_dict[new_module.type] = new_module
        module_instance_dict[new_module.type] = list()
    
    return module_dict, module_instance_dict


def generate_fault_driver(faults):
    module_header = f'module fault_driver (\n  input  [{len(faults)}:0] original_value;\n  output [{len(faults)}:0] faulty_value;\n)'
    module_footer = '\nendmodule'

    module_body = ''

    for i, fault in enumerate(faults):
        module_body += f'\n\n  // fault injection from {fault}\n  assign faulty_value[{i}] = 0;'

    return module_header + module_body + module_footer


if __name__ == '__main__':
    
    all_modules, all_module_instances = parse_file('chipyard.TestHarness.SmallBoomConfig.top.v')        #smallboomconfig should be 475 modules 
    tree = ModuleTree(all_modules['ChipTop'], all_modules, all_module_instances)
    tree.setup_tree()

    #print(tree)


    print(generate_fault_driver(['ALU/Adder:test', 'ALU/Adder:test2', 'Multdiv/Counter:test3']))

