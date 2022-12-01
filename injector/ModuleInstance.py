import hashlib
import re

class ModuleInstance:
    def __init__(self, module_type, instance_name):
        self.module = module_type
        self.name = instance_name

        self._parent = None
        self._children = list()

        self._faulty_child_paths = list()


    '''
    Gets list of all parent ModuleInstances, all the way to the top module.
    '''
    def get_all_parents(self, append_root=True):
        lst = list()
        current = self
        while (current._parent != None):
            lst.append(current)
            current = current._parent  #technically should only ever be 1 parent so maybe this shouldnt even be a list
        # append final "current" ie topmost
        if (append_root):
            lst.append(current)
        return lst

    '''
    Get string representation of all parent ModuleInstances, all the way to the top module.
    '''
    def get_path(self, include_root=True):
        path = ""
        for mi in reversed(self.get_all_parents(include_root)):
            path += "/{}".format(mi.name)
        return path


    '''
    Add list of references to child ModuleInstances
    '''
    def add_children(self, children):
        #self._children += children
        self._children.extend(children)


    '''
    Get list of names of all child ModuleInstances
    '''    
    def get_children_names(self):
        lst = list()
        for mi in self._children:
            lst.append(mi.name)
        return lst

    '''
    Get some child ModuleInstance by name
    '''
    def get_child_module_instance(self, child_name):
        if child_name not in self.get_children_names():
            print('No child of name {} for {} {}'.format(child_name, self.module.type, self.name))
            return
        for mi in self._children:
            if mi.name == child_name:
                return mi

    '''
    Mark fault in instance of a module and track where the path back to root
    Path format: /child1/child2/..../target:wire:bit
    '''
    def mark_fault(self, fault_path):
        # track fault path for fault i/o routing
        self._faulty_child_paths.append(fault_path)

        path_parts = re.findall(r'\/\w+', fault_path)
        
        if len(path_parts) > 1:
            child_name = path_parts[1][1:]

            # search through children looking for next child in path
            for child in self._children:
                if child.name == child_name:
                    path_remainder = re.findall(r'\/\w+(\/.*)', fault_path)[0]

                    child.mark_fault(path_remainder)

                    break
            
            # if child not found exit with an error
            else:
                print(f'Error: Could not find child {child_name} of parent {path_parts[0][1:]} in path {fault_path}.')
                exit(1)

        elif len(path_parts) == 0:
            print(f'Error: Invalid fault path: {fault_path}')
            exit(1)


    '''
    Modifies the module_text to inject all the necessary logic for the fault injection
    1. If it's the root module, add the fault_driver instance
    2. If it's not the root module, add the fault_inputs and fault_outputs to the module i/o
    3. For each faulty wire within this module, inject it by replacing original with faulty copy
    4. For each faulty wire in the children, modify the children instance i/o to pass faulty i/o down
    '''
    def inject_faults(self, root=False, fault_driver=None):
        # if no faulty wires or child modules don't do anything
        if len(self._faulty_child_paths) == 0:
            return

        # make deepcopy of the module before changing the module text
        self.module = self.module.copy()

        
        # dict to track which faults are associated with which child modules 
        child_faults = {}

        # inject faults in this module or organize wires to child modules
        for i, path in enumerate(self._faulty_child_paths):
            path_parts = re.findall(r'\/\w+', path)
        
            # if there's only one entry we've reached the final module
            if len(path_parts) == 1:
                wire_name_parts = re.findall(r':(\w+)', path)

                # inject fault into the module text
                fault_input_wire = 'fault_inputs' if len(self._faulty_child_paths) == 1 else f'fault_inputs[{i}]'
                fault_output_wire = 'fault_outputs' if len(self._faulty_child_paths) == 1 else f'fault_outputs[{i}]'

                self.module.inject_fault(wire_name_parts[0], fault_input_wire, fault_output_wire, wire_name_parts[1] if len(wire_name_parts) == 2 else None)

            # if there are more than one path parts then the fault is in a child
            else:
                child_name = path_parts[1][1:]
                
                # if first time seeing the child, create list to track fault indices
                if child_name not in child_faults:
                    child_faults[child_name] = list()

                child_faults[child_name].append(i)


        # iterate over children on fault path and modify their module i/o
        for child_name, fault_indices in child_faults.items():
            
            print(child_name, fault_indices)

            # determine fault input params mapping
            fault_input_string = ''
            fault_output_string = ''

            if len(fault_indices) > 1:
                fault_input_params = ''
                fault_output_params = ''

                for fault_index in fault_indices:
                    fault_input_params += f'fault_inputs[{fault_index}], '
                    fault_output_params += f'fault_outputs[{fault_index}], '

                fault_input_params = fault_input_params[:-2]
                fault_output_params = fault_output_params[:-2]

                fault_input_string = f'.fault_inputs({{{fault_input_params}}})'
                fault_output_string = f'.fault_outputs({{{fault_output_params}}})'

            else:
                fault_input_string = '.fault_inputs(fault_inputs)'
                fault_output_string = '.fault_outputs(fault_outputs)'

            

            print(child_name)

            new_child_type = self.get_child_module_instance(child_name).module.type
            child_declaration = re.findall(rf'{child_name} \(.*?\n', self.module.module_text, re.MULTILINE)[0]

            self.module.module_text = re.sub(rf'\w+ {child_name} \(.*?\n', new_child_type + ' ' + child_declaration + f'\t\t{fault_input_string},\n\t\t{fault_output_string},\n', self.module.module_text)


        # update the type of the new faulty module with sha256 hash to ensure uniqueness
        digest = hashlib.sha256(self.module.module_text.encode()).hexdigest()
        new_type = f'{self.module.type}_{digest}'

        # determine the fault i/o bounds
        fault_io_bounds = '' if len(self._faulty_child_paths) < 2 else f'[{len(self._faulty_child_paths) - 1}:0]'

        if root:
            # add fault driver module
            module_header = re.findall(rf'module \w+\(.*?\);\n', self.module.module_text, re.DOTALL | re.MULTILINE)[0]

            # create wires for all fault i/o and instantiate fault driver module in root
            wires = f'\twire {fault_io_bounds} fault_inputs;\n\twire {fault_io_bounds} fault_outputs;\n'
            driver_module = f'\t{fault_driver} fault_driver (\n\t\t.original_values(fault_outputs),\n\t\t.faulty_values(fault_inputs)\n);\n'

            self.module.module_text = re.sub(rf'module \w+\(.*?\);\n', module_header + wires + driver_module, self.module.module_text, flags= re.DOTALL | re.MULTILINE)
        
        else:
            # modify the input/output of the module

            # add fault_inputs and fault_outputs to module i/o
            mod_fault_input_wire = f'input\t\t{fault_io_bounds}\tfault_inputs,'
            mod_fault_output_wire = f'output\t\t{fault_io_bounds}\tfault_outputs,'
            self.module.module_text = re.sub(rf'(module ){self.module.type}(\(\n)', rf'\1{new_type}\2' + f'\t{mod_fault_input_wire}\n\t{mod_fault_output_wire}\n', self.module.module_text)

        self.module.type = new_type

            

    '''
    String representation for the ModuleInstance class
    '''
    def __str__(self):
        return '{} {}'.format(self.module.type, self.name)
    
    '''
    Extended string representation for also printing parents and children
    '''
    def print_details(self):
        return '== {} ==\n\tParents: {}\n\tChildren: {}'.format(
            str(self), 
            [str(parent) for parent in self._parents], 
            [str(child) for child in self._children]
        )