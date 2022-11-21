from Module import Module
from ModuleInstance import ModuleInstance
import re
from fault_driver import generate_fault_driver

class ModuleTree:
    def __init__(self, rootNode, all_modules, all_module_instances):        #valid modules = all_modules dict, rootNode = actual Module of the root
        self.root = rootNode
        self.rootInstance = ModuleInstance(self.root, "Root")
        self.all_modules = all_modules
        self.all_module_instances = all_module_instances
        self.all_module_instances[rootNode.type].extend([self.rootInstance])

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


    #Path format: /child1/child2/..../target:wire:bit

    '''
    Given some path, checks if it is a valid one
    '''
    def check_if_valid_path(self, path):
        data = path.strip().split(":")      #expecting nodes:wire:bit but also accomodates providing nodes:wire or nodes
        data.append("0")    #dummy val for unspecified bit. Will be ignored when only nodes or all nodes:wire:bit are provided
        raw_nodes = data[0].split("/")
        nodes = [n for n in raw_nodes if (not n.isspace() and n)]
        current_node = self.rootInstance
        if nodes[0] == current_node.name:
            nodes.pop(0)
        for i in range(0, len(nodes)):
            child_name = nodes[i]
            if child_name not in current_node.get_children_names():
                #print("broke on child = {}, current = {}".format(child_name, current_node.name))
                return False
            current_node = current_node.get_child_module_instance(child_name)
            if (i == len(nodes)-1):
                if (len(data) <= 2):        #only nodes, plus 0 dummy val
                    return True
                wire = data[1]
                bit = data[2]                
                if not current_node.module.is_valid_wire(wire):
                    print ("recognized module path, but wire unrecognized for target module")
                    return False
                return current_node.module.check_wire_bit(wire, int(bit))
                

    '''
    Grabs module as directed from input path
    '''
    def get_node_from_path(self, path):
        if not self.check_if_valid_path(path):
            print("invalid path")
            return
        rawnodes, wire, bit = path.strip().split(":")
        rawnodes = rawnodes.split("/")
        nodes = [n for n in rawnodes if (not n.isspace() and n)]
        current_node = self.rootInstance
        for n in nodes:
            current_node = current_node.get_child_module_instance(n)
        return current_node


    '''
    Main function to map fault IO throughout tree up to the root
    Expecting input such as (all_modules['ModB'], ['/Root/a_module_1/b_module_2', '/Root/a_module_2/b_module_1'], ['b_wire_1', 'b_wire_2', 'b_wire_3', 'b_wire_4'])
    '''
    def setup_fault_paths(self, module_type, list_of_paths_to_target_model_instances, list_of_wires):
        fault_bus_width = self._find_fault_bus_width(module_type, list_of_wires)
        print("num faults = " + str(fault_bus_width))
        num_faulty_module_instances = self._trace_fault_paths(list_of_paths_to_target_model_instances)
        print("num faulty module instances = " + str(num_faulty_module_instances))

    '''
    Checks how many of the given wires are valid ones within that module. Used for determining fault input bus width.
    '''
    def _find_fault_bus_width(self, module, list_of_wires):
        num = 0
        for w in list_of_wires:
            if module.is_valid_wire(w):
                num += 1
        return num

    '''
    Adds relative path of child faulty module instance to each module instance that is a parent of that child
    '''
    def _trace_fault_paths(self, list_of_target_module_paths):
        num_valid_paths = 0
        for target_module_path in list_of_target_module_paths:
            if (not self.check_if_valid_path(target_module_path)): 
                continue
            num_valid_paths+= 1
            raw_nodes = target_module_path.split("/")
            nodes = [n for n in raw_nodes if (not n.isspace() and n)]
            currentnode = self.rootInstance
            if nodes[0] != currentnode.name:    
                nodes.insert(0, currentnode.name)
            path_to_use = "/".join(nodes)
            for i in range(1, len(nodes)):    #skip searching for 0th entry, which will be root, bc you're already inside root. don't need to do it for the specific target module which will be last item in list, this is just for setting up the passthroughs--logic for the target module will likely be done differently
                above, below = path_to_use.split(currentnode.name)
                currentnode._faulty_child_paths.append(below)            
                currentnode = currentnode.get_child_module_instance(nodes[i])
        return num_valid_paths

    '''
    Inject all marked faults into the modules
    '''
    def inject_faults(self):
        # stack for tree traversal
        stack = []
        
        fault_driver = generate_fault_driver(self.rootInstance._faulty_child_paths)
        
        self.rootInstance.inject_faults(root=True, fault_driver=fault_driver.type)

        stack += self.rootInstance._children

        self.rootInstance._children.append(ModuleInstance(fault_driver, 'fault_driver'))
        

        while len(stack) > 0:
            inst = stack.pop()

            # inject faults in the current module instance
            inst.inject_faults()

            # add children to the stack
            stack += inst._children




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

    name = f'\033[93m{module_inst.name}\033[00m' if len(module_inst._faulty_child_paths) > 0 else module_inst.name

    inst_str = f'\033[94m{module_inst.module.type}\033[00m {name}'

    for i, child in enumerate(module_inst._children):
        last_child = i + 1 == len(module_inst._children)
        tree_symbol = '\u251c' if not last_child else '\u2514'

        inst_str += f'\n{spaces}{tree_symbol}\u2500{_inst_str(child, layer=spaces, last_child=last_child )}'

    return inst_str
