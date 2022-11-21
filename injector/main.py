import os
import re
import sys
from Module import Module
from ModuleTree import ModuleTree
from fault_driver import generate_fault_driver

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



if __name__ == '__main__':
    # Simple ALUUnit example

    # all_modules, all_module_instances = parse_file('alu.v')

    # tree = ModuleTree(all_modules['ALUUnit'], all_modules, all_module_instances)
    # tree.setup_tree()

    # tree.rootInstance.mark_fault('/Root/alu/:slt')
    # tree.rootInstance.mark_fault('/Root/alu/:_T_2')
    # tree.inject_faults()

    # tree.dump('output.v')


    # BOOM example

    all_modules, all_module_instances = parse_file('chipyard.TestHarness.SmallBoomConfig.top.v')        #smallboomconfig should be 475 modules 
    tree = ModuleTree(all_modules['ChipTop'], all_modules, all_module_instances)
    tree.setup_tree()


    tree.rootInstance.mark_fault('/Root/system/tile_prci_domain/tile_reset_domain/boom_tile/core/csr_exe_unit/alu/alu/:slt')
    tree.rootInstance.mark_fault('/Root/system/tile_prci_domain/tile_reset_domain/boom_tile/core/mem_units_0/maddrcalc/:_io_resp_valid_T_1')
    
    tree.inject_faults()
    tree.dump('output.v')



    print(tree)

