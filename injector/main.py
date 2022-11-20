import os
import re
import sys
from Module import Module
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



if __name__ == '__main__':
    
    # all_modules, all_module_instances = parse_file('chipyard.TestHarness.SmallBoomConfig.top.v')        #smallboomconfig should be 475 modules 
    # tree = ModuleTree(all_modules['ChipTop'], all_modules, all_module_instances)
    # tree.setup_tree()

    all_modules, all_module_instances = parse_file('test_verilog.txt')

    tree = ModuleTree(all_modules['Top'], all_modules, all_module_instances)
    tree.setup_tree()

    tree.setup_fault_paths(all_modules['ModC'], ['/Root/a_module_1/b_module_1/c_module_1', '/b_module_3/c_module_1', 'root/totally/invalidpath/toignore'], ['c_wire_1', 'invalidwire'])

    for ami in all_module_instances.keys():
        for mi in all_module_instances[ami]:
            if (len(mi._faulty_child_paths) != 0):
                print("\n" + str(mi))
                for path in mi._faulty_child_paths:
                    print("\t{} routes to faulty module {}".format(mi.name, path))
                
    
    """
    from this, we know that the width of each fault input bus will be 1 (num faults), that Root 
    will have 2 fault io sets and a_module_1, b_module_1, b_module_3 each have 1 fault io set. 
    We know that the target instance modules will each have 1 fault io  set, so I didn't think 
    it was necessary to add the logic here. I figure that we will likely add an additional step 
    to Tree.setup_fault_paths at the end that goes through each provided path and uses 
    Tree.get_node_from_path to get the actual target module instance and then apply whatever 
    changes we want to it.
    """

