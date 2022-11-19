
class ModuleInstance:
    def __init__(self, module_type, instance_name):
        self.module = module_type
        self.name = instance_name

        self._parent = None
        self._children = list()

        self._num_faulty_children = 0

    '''
    Gets list of all parent ModuleInstances, all the way to the top module.
    '''
    def get_all_parents(self):
        lst = list()
        current = self
        while (current._parent != None):
            lst.append(current)
            current = current._parent  #technically should only ever be 1 parent so maybe this shouldnt even be a list
        # append final "current" ie topmost
        lst.append(current)
        return lst

    '''
    Get string representation of all parent ModuleInstances, all the way to the top module.
    '''
    def get_path(self):
        path = ""
        for mi in reversed(self.get_all_parents()):
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