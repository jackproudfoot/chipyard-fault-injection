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

    '''
    Given some path, checks if it is a valid one
    '''
    def check_if_valid_path(self, path):      # path = string
        nodes = path.strip().split("/")
        current_node = self.rootInstance
        for n in nodes:
            if n.isspace() or not n:
                continue 
            child_name = n
            if child_name not in current_node.get_children_names():
                return False
            current_node = current_node.get_child_module_instance(child_name)
        return True

    '''
    Grabs module as directed from input path
    '''
    def get_node_from_path(self, path):
        if not self.check_if_valid_path(path):
            print("invalid path")
            return
        nodes = path.strip().split("/")
        current_node = self.rootInstance
        for n in nodes:
            if n.isspace() or not n:
                continue
            current_node = current_node.get_child_module_instance(n)
        return current_node


        
            

            
