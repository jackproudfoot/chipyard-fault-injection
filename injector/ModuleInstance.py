
class ModuleInstance:
    def __init__(self, module_type, instance_name):
        self.module = module_type
        self.name = instance_name

        self._parents = list()
        self._children = list()

    '''
    Add list of references to parent ModuleInstances
    '''
    def add_parents(self, parents):
        #self._parents += parents
        self._parents.extend(parents)

    '''
    Add list of references to child ModuleInstances
    '''
    def add_children(self, children):
        #self._children += children
        self._children.extend(children)

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