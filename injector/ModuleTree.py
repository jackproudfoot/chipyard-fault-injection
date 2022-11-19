from Module import Module
from ModuleInstance import ModuleInstance
import re

class ModuleTree:
    def __init__(self, rootNode, all_modules, all_module_instances):        #valid modules = all_modules dict, rootNode = actual Module of the root
        self.root = rootNode
        self.rootInstance = ModuleInstance(self.root, "Root")
        self.all_modules = all_modules
        self.all_module_instances = all_module_instances

    '''
    Entry point into parent-child recursion
    '''
    def setup_tree(self):
        self._find_children(self.rootInstance)
        
    '''
    Finds children of some given model instance. Sets up parent-child relationship and recursively operates on all child instances as well.
    '''
    def _find_children(self, module_node):
        possible_children = re.findall(r'\\n\s+(\w+) (\w+) ?\(', repr(module_node.module.module_text))       #gets (moduletype) (instance name)
        if len(possible_children) == 0:
            return

        for pc in possible_children:
            if pc[0] in self.all_modules.keys(): 
                child_module_instance = ModuleInstance(self.all_modules[pc[0]], pc[1])
                module_node.add_children([child_module_instance])
                child_module_instance._parent = module_node
                self._find_children(child_module_instance)
                self.all_module_instances[pc[0]].extend([child_module_instance])


    #Path format: /child1/child2/..../target:wire

    '''
    Given some path, checks if it is a valid one
    '''
    def check_if_valid_path(self, path):
        nodes, wire = path.strip().split(":")
        nodes = nodes.split("/")
        current_node = self.rootInstance
        for i in range(0, len(nodes)):
            n = nodes[i]
            if n.isspace() or not n:
                continue 
            child_name = n
            if child_name not in current_node.get_children_names():
                return False
            current_node = current_node.get_child_module_instance(child_name)
            if (i == len(nodes)-1):
                if wire == ".":
                    return True
                if not current_node.module.is_valid_wire(wire):
                    print ("recognized module path, but wire unrecognized for target module")
                    return False
        return True

    '''
    Grabs module as directed from input path
    '''
    def get_node_from_path(self, path):
        if not self.check_if_valid_path(path):
            print("invalid path")
            return
        nodes, wire = path.strip().split(":")
        nodes = nodes.split("/")
        current_node = self.rootInstance
        for n in nodes:
            if n.isspace() or not n:
                continue
            current_node = current_node.get_child_module_instance(n)
        return current_node


    '''
    Dump module text of all nodes in tree to file
    '''
    def dump(self, path):
        with open(path, 'w') as verilog_file:
            
            # dict to track what modules have already been written
            written_modules = {}
            
            # stack for pre-order traversal
            stack = []
            stack.append(self.rootInstance)

            while len(stack) > 0:
                inst = stack.pop()

                # if module has not already been written, write it
                if inst.module.type not in written_modules:
                    verilog_file.write(inst.module.module_text)
                    verilog_file.write('\n')
                    written_modules[inst.module.type] = True

                # add children to stack
                stack += inst._children





            


    def __str__(self):
        tree_str = _inst_str(self.rootInstance, last_child = True)

        return tree_str

def _inst_str(module_inst, layer = '', last_child = False):
    spaces = layer + f'\u2502 ' if not last_child else layer + f'  '
    inst_str = f'\033[94m{module_inst.module.type}\033[00m {module_inst.name}'

    for i, child in enumerate(module_inst._children):
        last_child = i + 1 == len(module_inst._children)
        tree_symbol = '\u251c' if not last_child else '\u2514'

        inst_str += f'\n{spaces}{tree_symbol}\u2500{_inst_str(child, layer=spaces, last_child=last_child )}'

    return inst_str

    


        
            

            
