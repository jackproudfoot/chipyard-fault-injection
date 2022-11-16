import os
import re
import sys
from Module import Module
from ModuleInstance import ModuleInstance

all_modules = dict()    #module name to Module
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

'''
    Finds children of some given model instance. Sets up parent-child relationship and recursively operates on all child instances as well.
'''
def find_children(module_instance):
    possible_children = re.findall(r'\\n\s+(\w+) (\w+) ?\(', repr(module_instance.module.module_text))       #gets (moduletype) (instance name)
    if len(possible_children) == 0:
        return

    for pc in possible_children:
        if pc[0] in all_modules.keys():
            child_module_instance = ModuleInstance(all_modules[pc[0]], pc[1])
            module_instance.add_children([child_module_instance])
            child_module_instance.add_parents([module_instance])
            find_children(child_module_instance)
            all_module_instances[pc[0]].extend([child_module_instance])
            

'''
    Entry point to find_children, given the String type of the top-level module.
'''
def start_finding_children_recursion(top_module):       #give string for Module type, not ModuleInstance
    if top_module in all_modules.keys():
        top_module_instance = ModuleInstance(all_modules[top_module], "Root")
        find_children(top_module_instance)
        return


# def check_parent_child(all_modules, parent_name, child_name):
#     if (parent_name in all_modules.keys() and child_name in all_modules.keys()):
#         child = all_modules[child_name]
#         parent = all_modules[parent_name]
#         if (child in parent._children and parent in child._parents):
#             print (parent.name + " <-> " + child.name)
#             return
#         elif (child in parent._children and parent not in child._parents) :
#             print ("parent " + parent.name + " has child " + child.name + " but child doesn't have parent")
#             return
#         elif (parent in child._parents and child not in parent._children):
#             print ("child " + child.name + " has parent " + parent.name + " but parent doesn't have child")
#             return

if __name__ == '__main__':
    
    all_modules, all_module_instances = parse_file('chipyard.TestHarness.SmallBoomConfig.top.v')        #smallboomconfig should be 475 modules 
    start_finding_children_recursion('ChipTop')
    for n in all_module_instances:
        m = all_module_instances[n]
        l = len(m)
        if (l == 0):
            print(n + " has " + str(l) + " instances ----------------------------")
        else: 
            print(n + " has " + str(l) + " instances")
    

   
   
   
   #From below code + parents/children logic moved to Module instead of ModuleInstance, found that the top-level module is ChipTop (the only module with 0 parents)

    # set_all_parent_children(all_modules)
    # count = 0
    # for n in all_modules:
    #     m = all_modules[n]
    #     if (len(m._parents) == 0):
    #         count += 1
    #         print(m.type + ": " + str(len(m._parents)) + " parents, " + str(len(m._children)) + " children")
    # print("num parentless modules = " + str(count))



