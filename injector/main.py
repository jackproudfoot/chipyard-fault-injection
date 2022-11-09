import os
import re
import sys
from mapping import Module

'''
Create dict of all modules with module name as key from some input file
'''
def parse_file(file_path):
    #file = open(file_path, 'r')
    file = open(os.path.join(sys.path[0], file_path), 'r')      
    text = file.read()
    file.close()

    module_texts = re.findall(r'(module\s+(\w+)\(.+?endmodule)', text, re.DOTALL)
    #print("num modules: " + str(len(module_texts)))
    all_modules = dict()
    for m_t in module_texts:
        new_module = Module(m_t[1], m_t[0])
        #all_modules.append(new_module)
        all_modules[new_module.type] = new_module
    
    
    # for m in all_modules:
    #     print(str(m))
    #     print("\n")
    return all_modules


def set_all_parent_children(all_modules):
    for parent_name in all_modules.keys():
        parent_module = all_modules[parent_name]
        possible_modules = re.findall(r'\\n\s+(\w+) (?:\w+) ?\(', repr(parent_module.module_text))
        #print(parent_module.name + " possible children: " + ", ".join(possible_modules))
        for mod in possible_modules:
            if str(mod) in all_modules.keys():
                child_module = all_modules[str(mod)]
                parent_module.add_children([child_module])
                child_module.add_parents([parent_module])
    return

def check_parent_child(all_modules, parent_name, child_name):
    if (parent_name in all_modules.keys() and child_name in all_modules.keys()):
        child = all_modules[child_name]
        parent = all_modules[parent_name]
        if (child in parent._children and parent in child._parents):
            print (parent.name + " <-> " + child.name)
            return
        elif (child in parent._children and parent not in child._parents) :
            print ("parent " + parent.name + " has child " + child.name + " but child doesn't have parent")
            return
        elif (parent in child._parents and child not in parent._children):
            print ("child " + child.name + " has parent " + parent.name + " but parent doesn't have child")
            return
    


if __name__ == '__main__':
    
    modules = parse_file('chipyard.TestHarness.SmallBoomConfig.top.v')        #smallboomconfig should be 475 modules
    # print(modules['ALU'].module_text)
    # print('\n\n')
    print(repr(modules['ALUExeUnit_1'].module_text))
    set_all_parent_children(modules)
    print("num modules: " + str(len(modules)) + "\n\n")
    # for n in modules:
    #     m = modules[n]
    #     print(m.name + ": " + str(len(m._parents)) + " parents, " + str(len(m._children)) + " children")
    
    # print(modules['ALU'])
    # check_module = modules['TileClockGater']
    # print(check_module.name + " has " + str(len(check_module._parents)) + " parents")
    # print(check_module.name + " has " + str(len(check_module._children)) + " children")

    # check_parent_child(modules, 'TileClockGater', 'AsyncResetRegVec_w1_i1')
    
    # for m in modules:
    #     print(m.name + ": ")

